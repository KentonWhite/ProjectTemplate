#' Read a Minitab Portable Worksheet with an .mtp3 file extension.
#'
#' This function will load the specified Minitab Portable Worksheet into
#' memory.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' mtp.reader('example.mtp', 'data/example.mtp', 'example')
mtp.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.mtp(filename),
         envir = .GlobalEnv)
}
