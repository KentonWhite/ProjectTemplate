#' Read a Minitab Portable Worksheet with an .mtp3 file extension.
#'
#' This function will load the specified Minitab Portable Worksheet into
#' memory.
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
#' \dontrun{mtp.reader('example.mtp', 'data/example.mtp', 'example')}
mtp.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.mtp(filename),
         envir = .TargetEnv)
}
