#' @describeIn preinstalled.readers Read an arbitrary file described in a \code{.file} file.
#'
#' A \code{.file} file must contain DCF that specifies the path to the data set
#' and which extension should be used from the dispatch table to load the data set.
#'
#' Examples of the DCF format and settings used in a .file file are shown
#' below:
#'
#' path: http://www.johnmyleswhite.com/ProjectTemplate/sample_data.csv
#' extension: csv
file.reader <- function(data.file, filename, variable.name)
{
  file.info <- translate.dcf(filename)
  file.type <- paste('\\.', file.info[['extension']], '$', sep = '')

  do.call(extensions.dispatch.table[[file.type]],
          list(data.file,
               file.info[['path']],
               variable.name))
}
