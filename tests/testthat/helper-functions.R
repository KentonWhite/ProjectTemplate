# Function to tidy up at the end of tests
tidy_up <- function() {
  objs <- setdiff(ls(envir = .TargetEnv), "tidy_up")
  rm(list = objs, envir = .TargetEnv)
}

# Determine available cache file formats
cache_file_formats <- "RData"
if (requireNamespace("qs", quietly = TRUE)) {
  cache_file_formats <- c(cache_file_formats, "qs")
}

# Function to set cache file format
set_cache_file_format <- function(cache_file_format) {
  if (cache_file_format != "RData") {
    config <- .read.config()
    config$cache_file_format <- cache_file_format
    .save.config(config)
  }

  cache_file_format
}
