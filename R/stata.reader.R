#' @describeIn preinstalled.readers Read a Stata file with a \code{.stata} file extension.
stata.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.dta(filename),
         envir = .TargetEnv)
}
