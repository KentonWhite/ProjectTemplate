#' Create a new template
#'
#' This function writes a skeleton directory structure for creating your own
#'   custom templates.
#'
#' @param target Name of the new template. It is created under the directory
#'   specified by \code{options('ProjectTemplate.templatedir')}, or, when
#'   missing, in the current directory.
#' @param source Name of an existing template to copy, defaults to the built in
#'   'minimal' template.
#'
#' @export
create.template <- function(target, source = 'minimal') {
  if (dirname(target) == '.') {
    target <- file.path(getOption('ProjectTemplate.templatedir', '.'),
                        target)
  }
  create.project(target, template = source)
}


#' Get the location of a template from its name
#'
#' Checks the configured \code{option('ProjectTemplate.templatedir')} for the
#' template. If no matching template was found the system templates are checked,
#' and finally the current directory is checked. If no template was found with
#' the given name an error is raised.
#'
#' @param template Character vector containing the name of the template
#'
#' @return Character vector containing the location of the template. If no
#'   template was found by the given name an error is raised.
#'
#' @keywords internal
#'
#' @rdname internal.get.template
.get.template <- function(template) {
  template.dir <- getOption('ProjectTemplate.templatedir')
  if (!is.null(template.dir) && dir.exists(file.path(template.dir, template))) {
    template.dir <- file.path(template.dir, template)
  } else {
    template.dir <- system.file(paste0('defaults/templates/', template),
                                package = 'ProjectTemplate')
  }
  if (template.dir == "") {
    template.dir <- file.path('.', template)
  }
  if (!dir.exists(template.dir)) {
    stop('No template with the name ', template, ' found.')
  }
  if (!.is.ProjectTemplate(template.dir)) {
    stop(template, ' is not a valid ProjectTemplate')
  }
  return(template.dir)
}
