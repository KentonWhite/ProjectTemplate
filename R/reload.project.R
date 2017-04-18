#' Reload or reset a project
#'
#' This function will clear the global environment and reload a project.  This is
#' useful when you've updated your data sets or changed your preprocessing scripts.
#' Any \code{sticky_variables} configuration parameter in \code{\link{project.config}}
#' will remain both in memory and (if present) in the cache by default. If the \code{reset} 
#' parameter is \code{TRUE}, then all variables are cleared from both the global
#' environment and the cache.
#'
#' @param ... Optional parameters passed to \code{\link{load.project}}
#' @param reset A boolean value, which if set \code{TRUE} clears the cache and everything
#'   in the global environment, including any \code{sticky_variables}
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
reload.project <- function(..., reset = FALSE)
{
  
  project_name <- .stopifnotproject("Change to a valid ProjectTemplate directory and run reload.project() again.")

  if (!reset) {
          if (!.is.cache.empty())
                  message("Items in cache will not be cleared\nUse reload.project(reset=TRUE) to clear cache also")
          clear()
  }
  else {
          clear(force = TRUE)
          clear.cache()
  }
  message("Reloading Project ...")
  load.project(...)
}
