# This file contains internal helper functions to determine whether a given path is a ProjectTemplate directory
# or not.

# The purpose is to allow user functions (load.project etc) to exit cleanly rather than try and perform their
# function when it's not appropriate
#
# main functions are:
#       .stopifnotproject()  which will stop if the path is not a ProjectTemplate
#       .stopifproject()  which will stop if the path is a ProjectTemplate
#
# It is intended that user functions will call one of these as appropriate near the beginning of their
# execution and they can supply an additional message to display to the user to tell them how to rectify
# the situation which caused their command to stop
#

# files that determine whether a directory is a ProjectTemplate project
.mandatory.files <- c("config/global.dcf", "cache", "data")

#' Test whether a given path is a ProjectTemplate project
#'
#' @param path Directory to check, defaults to the current working directory.
#'
#' @return Logical indicating whether the given path is a valid project.
#'
#' @keywords internal
#'
#' @rdname internal.is.ProjectTemplate
.is.ProjectTemplate <- function(path=getwd()) {
  check_files <- file.path(path, .mandatory.files)
  sum(file.exists(check_files)) == length(check_files)
}


#' Raise an error if given path is not a valid project
#'
#' Function to stop processing if the path is not a Project Template return the
#' project name if it is a Project Template directory.
#'
#' @param additional_message Optional message to show if the given path is not a
#'   valid project
#' @param path Path to check if it is a valid project
#'
#' @return Project name if it is a valid Project.
#'
#' @keywords internal
#'
#' @rdname internal.stopifnotproject
.stopifnotproject <- function(additional_message="", path=getwd()) {
  is.ProjectTemplate <- .is.ProjectTemplate(path)
  if (!is.ProjectTemplate) {
    directory <- ifelse(path == getwd(), "Current Directory: ", "Directory: ")

    message(
      paste0(c(paste0(directory, basename(path),
                      " is not a valid ProjectTemplate directory because one or more mandatory directories are missing.  ", 
                      "If you believe you are in a ProjectTemplate directory and seeing this message in error, try running migrate.project().  ", 
                      "migrate.project() will ensure the ProjectTemplate structure is consistent with your version of ProjectTemplate."),
               additional_message),
             sep = "\n")
    )
    .quietstop()
  }
  basename(path)
}

#' Raise an error if given path is a valid project
#'
#' Function to stop processing if the path is a Project Template.
#'
#' @param additional_message Optional message to show if the given path is not a
#'   valid project
#' @param path Path to check if it is a valid project
#'
#' @return No value is returned; this function is called for its side effects
#'
#' @keywords internal
#'
#' @rdname internal.stopifproject
.stopifproject <- function(additional_message="", path=getwd()) {
  is.ProjectTemplate <- .is.ProjectTemplate(path)
  if (is.ProjectTemplate) {
    directory <- ifelse(path == getwd(), "Current Directory: ", "Directory: ")
    message(
      paste0(c(paste0(directory, basename(path),
                      " is a ProjectTemplate directory"),
               additional_message),
             collapse = "\n")
    )
    .quietstop()
  }
}

#' Stop silently
#'
#' Temporarily disable \code{option(show.error.messages)} and stop execution.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @keywords internal deprecate
#'
#' @rdname internal.quietstop
.quietstop <- function() {
  few <- options(show.error.messages = FALSE)
  on.exit(options(few))
  stop()
}

