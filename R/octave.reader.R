#' @describeIn preinstalled.readers Read an Octave file with a \code{.m} file extension.
#'
#' This function will load the specified Octave file into memory using the
#' \code{foreign::read.octave} function.
octave.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.octave(filename),
         envir = .TargetEnv)
}
