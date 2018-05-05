#' @describeIn preinstalled.readers Read the Weka file format from files with the \code{.arff} extension.
#' @include add.extension.R
arff.reader <- function(filename, variable.name, ...) {
  .require.package('foreign')

  assign(variable.name,
         foreign::read.arff(filename, ...),
         envir = .TargetEnv)
}

.add.extension('arff', arff.reader)
