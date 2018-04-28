#' @describeIn preinstalled.readers Read an RData file with a \code{.rdata} or \code{.rda} file extension.
#'
#' This function will load the specified RData file into memory using the
#' \code{\link{load}} function. This may generate many data sets
#' simultaneously.
rdata.reader <- function(data.file, filename, variable.name)
{
  load(filename, envir = .TargetEnv)
}
