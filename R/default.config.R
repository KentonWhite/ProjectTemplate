.default.config.file <- system.file('defaults/config/default.dcf', package = 'ProjectTemplate')


#' Default configuration
#'
#' This list stores the configuration used for missing items
#' in the configuration of the current project.
#'
#' @include translate.dcf.R
default.config <- translate.dcf(.default.config.file)
