#' Automatically read data into memory
#'
#' The preinstalled readers are automatically loaded in an internal environment,
#' which can be displayed with \code{preinstalled.readers}. The reader functions
#' will load a data set into the specified global variable binding. These
#' functions are not meant to be called directly.
#'
#' Some file formats can contain more than one dataset. In this case all
#' datasets are loaded into separate variables in the format
#' \code{<variable.name>.<subset.name>}, where the \code{subset.name} is
#' determined by the reader automatically.
#'
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#'
#' @seealso \link{.add.extension}
#' @keywords internal datasets
#'
#' @return \code{preinstalled.readers} returns a list of the registered
#'   extensions. The reader functions return no value, they are called for their
#'   side effects.
preinstalled.readers <- function() {
  as.list(vapply(extensions.dispatch.table,
                 function(x){x$name},
                 FUN.VALUE = character(1)))
}

extensions.dispatch.table <- new.env()

.TargetEnv <- .GlobalEnv

#' Class to store reader in the dispatch table
#'
#' Normally you shouldn't need to construct an object of this class. Should you
#' need to do so, call \code{data_reader$new(name, reader)}.
#'
#' @field name Display name for the reader
#' @field reader Closure to import data
#'
#' @usage data_reader
#'
#' @importFrom R6 R6Class
#'
#' @keywords internal
data_reader <- R6::R6Class("data_reader",
  public = list(
    name = NULL,
    reader = NULL,
    initialize = function(name, reader) {
      self$name = name
      self$reader = reader
    },
    print = function(...) {
      cat(format(self), sep = "\n")
    },
    format = function(...) {
      format(self$name, justify = "left")
    }
  )
)

# Create an explicit NULL reader for cache only variables and unkown file types
null_reader <- data_reader$new('NULL', NULL)

#' Display the reader name in tibbles
#'
#' @param x reader for which to show the type summary
#'
#' @export
#' @keywords internal
type_sum.data_reader <- function(x) {
  format(x)
}
