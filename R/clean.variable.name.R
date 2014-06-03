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
#' @return A translated variable name.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{clean.variable.name('example_1')}
clean.variable.name <- function(variable.name)
{
  variable.name <- gsub('^[^a-zA-Z0-9]+', '', variable.name, perl = TRUE)
  variable.name <- gsub('[^a-zA-Z0-9]+$', '', variable.name, perl = TRUE)
  variable.name <- gsub('_+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('-+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\s+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\.+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('[\\\\/]+', '.', variable.name, perl = TRUE)
  variable.name <- make.names(variable.name)
  return(variable.name)
}
