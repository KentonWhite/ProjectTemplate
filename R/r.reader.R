#' @describeIn preinstalled.readers Read an R source file with a \code{.R} file
#'   extension.
#'
#' This function will call source on the specified R file, executing the code
#' inside of it as a way of generating data sets dynamically, as in many Monte
#' Carlo applications.
#'
#' @include add.extension.R
r.reader <- function(filename, variable.name, ...) {
  source(filename, ...)
}

.add.extension("R", r.reader)
