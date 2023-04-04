library(tools)

out_dir <- "vendor_r/src/contrib"

tools::write_PACKAGES(dir = out_dir, fields = NULL,
  type = c("source"),
  verbose = FALSE, unpacked = FALSE, subdirs = FALSE,
  latestOnly = TRUE, addFiles = FALSE, rds_compress = "xz",
  validate = FALSE)
