#' Cache a data set for faster loading.
#'
#' This function will store a copy of the named data set in the \code{cache}
#' directory. This cached copy of the data set will then be given precedence
#' at load time when calling \code{\link{load.project}}. Cached data sets are
#' stored as \code{.RData} files.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#' @examples
#' library('ProjectTemplate')
#' load.project()
#'
#' cache('dataset1')
cache <- function(variable)
{
  save(list = variable,
       envir = .GlobalEnv,
       file = file.path('cache',
                        paste(variable, '.RData', sep = '')))
}
