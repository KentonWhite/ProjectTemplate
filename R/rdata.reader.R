#' Read an RData file with a .rdata or .rda file extension.
#'
#' This function will load the specified RData file into memory using the
#' \code{\link{load}} function. This may generate many data sets
#' simultaneously.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' rdata.reader('example.RData', 'data/example.RData', 'example')
rdata.reader <- function(data.file, filename, variable.name)
{
  load(filename, envir = .GlobalEnv)
}
