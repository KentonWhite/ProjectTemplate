#' @describeIn preinstalled.readers Read an Octave file with a \code{.m} file extension.
#'
#' This function will load the specified Octave file into memory using the
#' \code{foreign::read.octave} function.
#'
#' @include add.extension.R
octave.reader <- function(filename, variable.name, ...) {
  .require.package('foreign')

  assign(variable.name,
         foreign::read.octave(filename),
         envir = .TargetEnv)
}

.add.extension("m", octave.reader)
