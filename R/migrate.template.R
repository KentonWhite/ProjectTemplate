#' Migrate a template to a new version of ProjectTemplate
#'
#' This function updates a skeleton project to the current version of
#'   ProjectTemplate.
#'
#' @param template Name of the template to upgrade.
#'
#' @export
migrate.template <- function(template) {
  oldwd <- setwd(.get.template(template))
  on.exit(setwd(oldwd), add = TRUE)

  migrate.project()
}
