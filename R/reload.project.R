#' Reload a project from scratch.
#'
#' This function will clear the global environment and reload a project
#' from scratch. This is useful when you've updated your data sets or
#' changed your preprocessing scripts.
#'
#' @param envir The environment, defaults to the global environment.  In most
#'   use cases this parameter can be omitted.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{load.project()
#'
#' reload.project()}
reload.project <- function(envir = .GlobalEnv)
{
  rm(list = ls(envir), pos = envir)
  load.project(envir = envir)
}
