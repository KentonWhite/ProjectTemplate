#' Show information about the current project.
#'
#' This function will show the user all of the information that
#' ProjectTemplate has about the current project. This information is
#' gathered when \code{\link{load.project}} is called. At present,
#' ProjectTemplate keeps a record of the project's configuration settings,
#' all packages that were loaded automatically and all of the data sets that
#' were loaded automatically. The information about autoloaded data sets
#' is used by the \code{\link{cache.project}} function.
#'
#' @param envir The environment, defaults to the global environment.  In most
#'   use cases this parameter can be omitted.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @seealso \code{\link{create.project}}, \code{\link{load.project}},
#'   \code{\link{get.project}}, \code{\link{cache.project}}
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{load.project()
#'
#' show.project()}
show.project <- function(envir = .GlobalEnv)
{
  print(get.project(envir))
}
