#' Require a package for use in the project
#'
#' This function will require the given package. If the package is not installed
#' it will stop execution and print a message to the user instructing them which
#' package to install and which function caused the error.
#'
#' @param package.name A character vector containing the package name.
#'   Must be a valid package name installed on the system.

#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{require.project('PackageName')}
require.package <- function(package.name)
{
  # Temporarily disable warnings
  old.options <- options(warn=-1)
  on.exit(options(old.options))
  if (!require(package.name, character.only = TRUE)) {
    function.name <- deparse(sys.calls()[[sys.nframe()-1]])
    stop(paste(function.name, ' requires package ', package.name, '.\nPlease install ', package.name, ' by running install.packages("', package.name, '") and then try re-running project.load()', sep = ''), call. = FALSE)
  }
}
