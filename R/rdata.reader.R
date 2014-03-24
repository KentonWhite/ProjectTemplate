#' Read an RData file with a .rdata or .rda file extension.
#'
#' This function will load the specified RData file into memory using the
#' \code{\link{load}} function. This may generate many data sets
#' simultaneously.
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{rdata.reader('example.RData', 'data/example.RData', 'example')}
rdata.reader <- function(data.file, filename, variable.name)
{
  load(filename, envir = .TargetEnv)
}
