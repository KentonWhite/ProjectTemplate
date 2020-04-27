#' Translate a file name into a valid R variable name.
#'
#' This function will translate a file name into a name that is a valid
#' variable name in R. Non-alphabetic characters on the boundaries of the
#' file name will be stripped; non-alphabetic characters inside of the file
#' name will be replaced with dots.
#'
#' @param variable.name A character vector containing a variable's proposed
#'  name that should be standardized.
#'
#' @param config A list of configuration variables.  Defaults to those
#'  loaded by load.project
#' 
#' @return A translated variable name.
#'
#' @keywords internal
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{clean.variable.name('example_1')}
clean.variable.name <- function(variable.name, config = .load.config())
{
  variable.name <- gsub('^[^a-zA-Z0-9]+', '', variable.name, perl = TRUE)
  variable.name <- gsub('[^a-zA-Z0-9]+$', '', variable.name, perl = TRUE)
  if(!config$underscore_variables) {
    variable.name <- gsub('_+', '.', variable.name, perl = TRUE)    
  }
  variable.name <- gsub('-+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\s+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\.+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('[\\\\/]+', '.', variable.name, perl = TRUE)
  variable.name <- make.names(variable.name)
  return(variable.name)
}
