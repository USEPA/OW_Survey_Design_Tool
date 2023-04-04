out_dir <- "vendor_r/src/contrib"

repoUrl = "https://cloud.r-project.org"

dir.create("junktemp")
download.packages(c("sf"), destdir = "junktemp", repos = repoUrl)
sf_pkg <- list.files("junktemp")[1]
devtools::build(pkg = paste("junktemp", sf_pkg, sep = "/"), path = out_dir, binary = TRUE)
unlink("junktemp", recursive = TRUE)