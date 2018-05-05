#' @describeIn preinstalled.readers Read an RData file with a \code{.rdata} or
#'   \code{.rda} file extension.
#'
#' This function will load the specified RData file into memory using the
#' \code{\link{load}} function. This may generate many data sets simultaneously.
#'
#' @include add.extension.R
rdata.reader <- function(filename, variable.name, ...) {
  load(filename, envir = .TargetEnv)
}

.add.extension('rdata', rdata.reader)
.add.extension('rda', rdata.reader)
