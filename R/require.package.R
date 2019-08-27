#' Require a package for use in the project
#'
#' This functions will require the given package. If the package is not installed
#' it will stop execution and print a message to the user instructing them which
#' package to install and which function caused the error.
#'
#' The function \code{.require.package} is called by internal code. It will
#' attach the package to the search path (with a warning) only if the
#' compatibility configuration \code{attach_internal_libraries} is set to
#' \code{TRUE}.  Normally, packages used for loading data are not
#' needed on the search path, but not loading them might break existing code.
#' In a forthcoming version this compatibility setting will be removed,
#' and no packages will be attached to the search path by internal code.
#'
#' @param package.name A character vector containing the package name.
#'   Must be a valid package name installed on the system.
#' @param attach Should the package be attached to the search path (as with
#'   \code{\link{library}}) or not (as with \code{\link{loadNamespace}})?
#'   Defaults to \code{TRUE}. (Internal code will use \code{FALSE} by default
#'   unless a compatibility switch is set, see below.)
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{require.package('PackageName')}
#' @importFrom utils install.packages
require.package <- function(package.name, attach = TRUE)
{
  success <- .attach.or.add.namespace(package.name, attach)
  if (!success) {
    install.packages(package.name)
    message(paste('Trying to install the', package.name, sep = ' '))
    success <- .attach.or.add.namespace(package.name, attach)
    if(!success) {
      function.name <- deparse(sys.calls()[[sys.nframe()-1]], nlines = 1)
      stop(paste(function.name, ' requires package ', package.name, '.\nPlease install ', package.name, ' by running install.packages("', package.name, '") and then try re-running load.project()', sep = ''), call. = FALSE)
    }
  }

  invisible(NULL)
}


#' Attach a package or add a namespace
#'
#' Internal method to attach a package or only add the namespace.
#'
#' @param package.name name of the package to load, as a character vector
#' @param attach boolean indicating whether to attach the package in the global namespace
#'
#' @keywords internal
#'
#' @return Boolean indicating whether the package was successfully loaded
#'
#' @rdname internal.attach.or.add.namespace
.attach.or.add.namespace <- function(package.name, attach) {
  if (attach) {
    success <- require(package.name, character.only = TRUE)
  } else {
    success <- requireNamespace(package.name)
  }
  return(success)
}

#' Require internal package
#'
#' Internal method to require a package that is necessary for the internal
#' functioning of ProjectTemplate. Never attaches the package unless
#' configured to do so in global.dcf (which throws a warning).
#'
#' @param package.name name of the package to load, as a character vector
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @keywords internal
#'
#' @rdname internal.require.package
.require.package <- function(package.name) {
  my.config <- if (.has.project()) get.project()$config else .new.config
  attach_internal <- my.config[['attach_internal_libraries']]
  if (attach_internal) {
    warning('Loading library ', package.name, ' into workspace as a side effect of loading data.\n',
            '  Normally, there is no need to attach a package for this purpose.\n',
            '  To turn off this warning, change the "attach_internal_libraries" setting in your\n',
            '  configuration to FALSE.')
  }
  require.package(package.name, attach = attach_internal)
}
