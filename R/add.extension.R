#' Associate a reader function with an extension.
#'
#' This function will associate an extension with a custom reader function.
#'
#' @section Warning:
#' This interface should not be considered as stable and is likely to be
#' replaced by a different mechanism in a forthcoming version of this package.
#'
#' @rdname add.extension
#' @param extension The extension of the new data file.
#' @param reader The function to use when reading the data file. It MUST accept
#'   three arguments: \code{filename}, \code{variable.name} and \code{...} (in
#'   that order and called by those names).  The function should read the
#'   contents of the file \code{filename}, and save it into the workspace under
#'   the name \code{variable.name}.  The \code{...} argument is just an optional
#'   interface for the \code{file.reader} to pass in extra options.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#' @seealso \link{preinstalled.readers}
#' @examples
#' \dontrun{.add.extension('foo', foo.reader)}
#'
#' @importFrom utils glob2rx
#'
#' @include preinstalled.readers.R
.add.extension <- function(extension, reader) {
  reader.name <- as.character(substitute(reader))
  reader <- match.fun(reader)
  if (!identical(names(formals(reader)),
                 c("filename", "variable.name", "..."))) {
    warning("A reader with non-standard arguments detected.\n",
            "Assuming old style arguments, for now will be wrapped in a ",
            "helper function.\n",
            "In a future version this will become an error.")
    # Old style reader: define a function with the new style arguments that
    # calls the function that was passed in. Because this happens in a closure
    # the reference to reader will still exist outside once .add_extension
    # finishes. Can't reuse the old name because that causes a recursion error.
    func_store <- function(filename, variable.name, ...) {
      reader(basename(filename), filename, variable.name)
    }
  } else {
    # New style reader, store reference temporarily (see branch above)
    func_store <- reader
  }
  # Store the, possibly wrapped, function in the environment
  key <- glob2rx(paste0("*.", extension), trim.head = TRUE)
  extensions.dispatch.table[[key]] <- data_reader$new(reader.name, func_store)
}
