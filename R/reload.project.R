#' Reload a project from scratch.
#'
#' This function will clear the global environment and reload a project
#' from scratch. This is useful when you've updated your data sets or
#' changed your preprocessing scripts.
#'
#' @param override.config Named list, allows overriding individual configuration
#'   items.
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
reload.project <- function(override.config = NULL)
{
  rm(list = ls(.TargetEnv), pos = .TargetEnv)
  load.project(override.config = override.config)
}
