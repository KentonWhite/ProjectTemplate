#' Read an MP3 file with a .mp3 file extension.
#'
#' This function will load the specified MP3 file into memory using the
#' tuneR package. This is useful for working with music files as a data
#' set.
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
#' \dontrun{mp3.reader('example.mp3', 'data/example.mp3', 'example')}
mp3.reader <- function(data.file, filename, variable.name)
{
  .require.package('tuneR')

  assign(variable.name,
         tuneR::readMP3(filename),
         envir = .TargetEnv)
}
