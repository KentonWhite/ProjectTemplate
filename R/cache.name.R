#' Translate a variable name into a file name for caching.
#'
#' This function will translate a variable name into a form that is
#' suitable as a filename on most OS's.
#'
#' @return A translated variable name.
#'
#' @examples
#' cache.name('example.1')
cache.name <- function(data.filename)
{
  return(gsub('\\..*', '', data.filename, perl = TRUE))
}
