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
#' @param reader The function to use when reading the data file.  It should
#'   accept three arguments: \code{data.file}, \code{filename} and
#'   \code{variable.name} (in that order).  The function should read the
#'   contents of the file \code{filename}, and save it into the workspace
#'   under the name \code{variable.name}.  The \code{data.file} argument
#'   is just a relative file name and can be ignored.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @examples
#' \dontrun{.add.extension('foo', foo.reader)}
#' @include preinstalled.readers.R

.add.extension <- function(extension, reader) {
  key <- paste('\\.', extension, '$', sep='')
  extensions.dispatch.table[[key]] <- reader
}
