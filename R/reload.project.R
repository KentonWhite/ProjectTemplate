#' Reload a project from scratch.
#'
#' This function will clear the global environment and reload a project
#' from scratch. This is useful when you've updated your data sets or
#' munging code.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#' load.project()
#'
#' reload.project()
reload.project <- function()
{
  rm(list = ls(.GlobalEnv), pos = .GlobalEnv)
  load.project()
}
