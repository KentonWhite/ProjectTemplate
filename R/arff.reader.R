#' @describeIn preinstalled.readers Read the Weka file format from files with the \code{.arff} extension.
arff.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.arff(filename),
         envir = .TargetEnv)
}
