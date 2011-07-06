#' Translate a file name into a valid R variable name.
#'
#' This function will translate a file name into a name that is a valid
#' variable name in R. Non-alphabetic characters will be either stripped
#' or replaced with dots.
#'
#' @return A translated variable name.
#'
#' @examples
#' clean.variable.name('example_1')
clean.variable.name <- function(variable.name)
{
  variable.name <- gsub('^[^a-zA-Z0-9]+', '', variable.name, perl = TRUE)
  variable.name <- gsub('[^a-zA-Z0-9]+$', '', variable.name, perl = TRUE)
  variable.name <- gsub('_+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('-+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\s+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\.+', '.', variable.name, perl = TRUE)
  variable.name <- make.names(variable.name)
  return(variable.name)
}
