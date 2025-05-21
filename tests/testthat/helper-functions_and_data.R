#' Tidy up at the end of a test
#'
#' @return \code{\link{NULL}}.
#'
#' @keywords tests
tidy_up <- function() {
  objs <- ls(envir = .TargetEnv)
  rm(list = objs, envir = .TargetEnv)
}

# Character vector holding the available cache file formats for testing
cache_file_formats <- "RData"
if (requireNamespace("qs", quietly = TRUE)) {
  cache_file_formats <- c(cache_file_formats, "qs")
}

#' Set cache file format for testing
#'
#' @param cache_file_format A character string.
#'
#' @return An invisible character string holding the chosen cache file format.
#'
#' @keywords tests
set_cache_file_format <- function(cache_file_format) {
  if (cache_file_format != "RData") {
    config <- .read.config()
    config$cache_file_format <- cache_file_format
    .save.config(config)
  }

  invisible(cache_file_format)
}
