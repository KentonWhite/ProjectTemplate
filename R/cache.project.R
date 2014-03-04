#' Cache a project's data sets in binary format.
#'
#' This function will cache all of the data sets that were loaded by
#' the \code{\link{load.project}} function in a binary format that is
#' easier to load quickly. This is particularly useful for data sets
#' that you've modified during a slow munging process that does not
#' need to be repeated.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @seealso \code{\link{create.project}}, \code{\link{load.project}},
#'   \code{\link{get.project}}, \code{\link{show.project}}
#'
#' @examples
#' library('ProjectTemplate')
#' \dontrun{load.project()
#'
#' cache.project()}
cache.project <- function()
{
  for (dataset in get.project()[['data']])
  {
    message(paste('Caching', dataset))
    cache(dataset)
  }
}
