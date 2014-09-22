#' Migrates a project from a previous version of ProjectTemplate
#'
#' This function automatically performs all necessary steps to migrate an existing project
#' so that it is compatible with this version of ProjectTemplate
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @seealso \code{\link{create.project}}
#'
#' @include load.project.R
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{migrate.project()}
migrate.project <- function()
{
  my.project.info <- list()

  message('Migrating project configuration')

  config <- .load.config()

  if (.check.version(config, warn.migrate = FALSE) == 0) {
    message("Already up to date.")
    return(invisible(NULL))
  }

  config$version <- .package.version()
  write.dcf(config, 'config/global.dcf')

}
