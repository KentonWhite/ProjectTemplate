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
  # get all data related to the project
  project_data <- unique(c(get.project()[['data']], .cached.variables()))
  
  # and cache each one (already cached items will be re-cached if they have changed)
  for (dataset in project_data)
  {
    message(paste('Caching', dataset))
    cache(dataset)
  }
}
