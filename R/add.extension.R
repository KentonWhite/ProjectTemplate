#' Associate a reader function with an extension.
#'
#' This function will associate an extension with a custom reader function.
#'
#' @param extension The extension of the new data file.
#' @param reader The function to user when reading the data file.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' \dontrun{add.extension('foo', foo.reader)}
#' @include extensions.dispatch.table.R

add.extension <- function(extension, reader) {
	key <- paste('\\.', extension, '$', sep='')
	extensions.dispatch.table[[key]] <- reader
	unlockBinding('extensions.dispatch.table', asNamespace('ProjectTemplate'))
	assign('extensions.dispatch.table', extensions.dispatch.table,
		envir = asNamespace('ProjectTemplate')
	)
	lockBinding('extensions.dispatch.table', asNamespace('ProjectTemplate'))
}