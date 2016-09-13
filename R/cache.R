#' Cache a data set for faster loading.
#'
#' This function will store a copy of the named data set in the \code{cache}
#' directory. This cached copy of the data set will then be given precedence
#' at load time when calling \code{\link{load.project}}. Cached data sets are
#' stored as \code{.RData} files.
#' 
#' Sometimes it can take a while to cache large variables, which causes 
#' \code{load.project()} to run slowly if values are cached during munging.  If the
#' \code{always} variable is set to \code{FALSE}, then caching is skipped if the 
#' variable is already in the cache.  The \code{clear.cache("variable")} command
#' can be run to flush individual items from the cache.
#'
#' @param variable A character vector containing the name of the variable to
#'  be saved.
#' @param always if \code{TRUE} then the cache is always updated, otherwise it is not
#'  if there the variable has been cached previously
#' @param ... additional arguments passed to \code{\link{save}}
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#' @examples
#' library('ProjectTemplate')
#' \dontrun{create.project('tmp-project')
#'
#' setwd('tmp-project')
#'
#' dataset1 <- 1:5
#' cache('dataset1')
#'
#' setwd('..')
#' unlink('tmp-project')}
cache <- function(variable, always=TRUE, ...)
{
  stopifnot(length(variable) == 1)
  if (!is.cached(variable) | always)
       save(list = variable,
       envir = .TargetEnv,
       file = .cache.file(variable),
       ...)
}

#' Check whether a variable is in the cache
#'
#' This function will determine if a variable is stored in the \code{cache}
#' directory. 
#' 
#' @param variable A character string containing the name of the variable to
#'  be checked.
#' 
#' @return \code{TRUE} if the variable exists in the cache, \code{FALSE} otherwise
#'
#' @export
#' @examples
#' library('ProjectTemplate')
#' \dontrun{is.cached('mapdata')
#' }
is.cached <- function(variable)
{
  stopifnot(length(variable) == 1)
  if (file.exists(.cache.file(variable))) return (TRUE)
  return (FALSE)
}

.cache.file <- function(variable) file.path('cache', paste0(variable, '.RData'))

