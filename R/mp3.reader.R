#' @describeIn preinstalled.readers Read an MP3 file with a \code{.mp3} file extension.
#'
#' This function will load the specified MP3 file into memory using the
#' tuneR package. This is useful for working with music files as a data
#' set.
mp3.reader <- function(data.file, filename, variable.name)
{
  .require.package('tuneR')

  assign(variable.name,
         tuneR::readMP3(filename),
         envir = .TargetEnv)
}
