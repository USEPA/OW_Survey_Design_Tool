library(stringr)
library(tools)
args <- commandArgs(trailingOnly = TRUE)

repoUrl = "https://packagemanager.rstudio.com/cran/__linux__/jammy/latest"
options(repos = repoUrl)

# Test if a package destination directory was passed as an argument
if (length(args) == 0) {
  stop("Usage: R -f download_packages.R destination_directory package1,package2,package3", call. = FALSE)
}

# Create the directory
if (!dir.exists(args[1])) {
        message("Creating the directory")
        dir.create(args[1], recursive = TRUE)
}

# Split the packages into a character list
input_packs <- unlist(str_split(args[2], ","))

message(input_packs)

options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), 
        paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))

# Get packages function to get the packages and dependencies
get_packages <- function(packs) {
        message("Getting the package dependencies")
        packages <- unlist(
                tools::package_dependencies(packs, available.packages(),
                        which = c("Depends", "Imports"), recursive = TRUE
                )
        )
        packages <- union(packs, packages)
        packages
}

# Get the package dependencies
packages <- get_packages(input_packs)

download_and_build_package <- function(pack) {
        dir.create("junktemp")
        download.packages(c(pack), destdir = "junktemp")
        pkg <- list.files("junktemp")[1]
        devtools::build(pkg = paste("junktemp", pkg, sep = "/"), path = args[1], binary = TRUE)
        unlink("junktemp", recursive = TRUE)
}

packages_needing_to_be_built <- c("sf")

# Download the packages from the repository
message(paste("Downloading the packages and dependencies to", args[1], sep = " "))
download.packages(setdiff(packages, packages_needing_to_be_built), destdir = args[1])

for (p in intersect(packages, packages_needing_to_be_built)) {
        message(paste("Package", p, "requires special handling", sep = " "))
        download_and_build_package(p)
        cat(p, file = "r-github-actions-build-deps.txt", sep = "\n", append = TRUE)
}

if ("rmarkdown" %in% packages) {
        cat("pandoc", file = "r-github-actions-build-deps.txt", sep = "\n", append = TRUE)
}

message("Completed downloading packages")

tools::write_PACKAGES(dir = args[1], fields = NULL,
  type = c("source"),
  verbose = FALSE, unpacked = FALSE, subdirs = FALSE,
  latestOnly = TRUE, addFiles = FALSE, rds_compress = "xz",
  validate = FALSE)

message("Wrote package description files")
