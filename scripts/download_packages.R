library(stringr)
args <- commandArgs(trailingOnly = TRUE)

repoUrl = "https://packagemanager.rstudio.com/cran/__linux__/jammy/latest"

# Test if a package destination directory was passed as an argument
if (length(args) == 0) {
  stop("Usage: R -f download_packages.R destination_directory package1,package2,package3", call. = FALSE)
}

# Create the directory
if (!dir.exists(args[1])) {
        # message("Creating the directory")
        dir.create(args[1], recursive = TRUE)
}

# Split the packages into a character list
input_packs <- unlist(str_split(args[2], ","))

# message(input_packs)

options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), 
        paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))

# Get packages function to get the packages and dependencies
get_packages <- function(packs) {
        # message("Getting the package dependencies")
        packages <- unlist(
                tools::package_dependencies(packs, available.packages(),
                        which = c("Depends", "Imports"), recursive = TRUE
                )
        )
        # buildpack_includes <- c("shiny", "forecast", "Rserve", "plumber")
        # packages_in_buildpack <- unlist(
        #         tools::package_dependencies(buildpack_includes, available.packages(),
        #                 which = c("Depends", "Imports"), recursive = TRUE
        #         )
        # )
        # packages <- setdiff(union(packs, packages), union(packages_in_buildpack, buildpack_includes))
        packages <- union(packs, packages)
        packages
}

# Get the package dependencies
packages <- get_packages(input_packs)

# Download the packages from the repository
# message(paste("Downloading the packages and dependencies to", args[1], sep = " "))

if ("sf"  %in% packages) {
        download.packages(setdiff(packages, c("sf")), destdir = args[1], repos = repoUrl)
        write("has_sf=TRUE", stdout())
} else {
        download.packages(packages, destdir = args[1], repos = repoUrl)
        write("has_sf=FALSE", stdout())
}

# message("Completed downloading packages")