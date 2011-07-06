#' Read an R source file with a .R file extension.
#'
#' This function will call source on the specified R file, executing the
#' code inside of it as a way of generating data sets dynamically, as in
#' many Monte Carlo applications.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' r.reader('example.R', 'data/example.R', 'example')
r.reader <- function(data.file, filename, variable.name)
{
  source(filename)
}
