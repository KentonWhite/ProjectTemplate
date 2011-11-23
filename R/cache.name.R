#' Translate a variable name into a file name for caching.
#'
#' This function will translate a variable name into a form that is
#' suitable as a filename on most OS's.
#'
#' @param data.filename The variable name to be translated into a filename.
#'
#' @return A translated variable name.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{cache.name('example.1')}
cache.name <- function(data.filename)
{
  return(gsub('\\..*', '', data.filename, perl = TRUE))
}
