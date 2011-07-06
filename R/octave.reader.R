#' Read an Octave file with a .m file extension.
#'
#' This function will load the specified Octave file into memory.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' octave.reader('example.m', 'data/example.m', 'example')
octave.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.octave(filename),
         envir = .GlobalEnv)
}
