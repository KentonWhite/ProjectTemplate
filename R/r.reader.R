#' Read an R source file with a .R file extension.
#'
#' This function will call source on the specified R file, executing the
#' code inside of it as a way of generating data sets dynamically, as in
#' many Monte Carlo applications.
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#' @param envir The environment, defaults to the global environment.  In most
#'   use cases this parameter can be omitted.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{r.reader('example.R', 'data/example.R', 'example')}
r.reader <- function(data.file, filename, variable.name, envir = .GlobalEnv)
{
  source(filename, local = envir)
}
