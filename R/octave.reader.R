#' Read an Octave file with a .m file extension.
#'
#' This function will load the specified Octave file into memory.
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#' @param envir The environment, defaults to the global environment.  In most
#'   use cases this parameter can be omitted.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{octave.reader('example.m', 'data/example.m', 'example')}
octave.reader <- function(data.file, filename, variable.name, envir = .GlobalEnv)
{
  require.package('foreign')

  assign(variable.name,
         read.octave(filename),
         envir = envir)
}
