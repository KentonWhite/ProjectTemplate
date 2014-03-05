#' Read an arbitrary file described in a .file file.
#'
#' This function will load all of the data sets described in the specified
#' .file file into the global environment. A .file file must contain DCF
#' that specifies the path to the data set and which extension should be
#' used from the dispatch table to load the data set.
#'
#' Examples of the DCF format and settings used in a .file file are shown
#' below:
#'
#' path: http://www.johnmyleswhite.com/ProjectTemplate/sample_data.csv
#' extension: csv
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{file.reader('example.file', 'data/example.file', 'example')}
file.reader <- function(data.file, filename, variable.name)
{
  file.info <- translate.dcf(filename)
  file.type <- paste('\\.', file.info[['extension']], '$', sep = '')

  do.call(extensions.dispatch.table[[file.type]],
          list(data.file,
               file.info[['path']],
               variable.name))
}
