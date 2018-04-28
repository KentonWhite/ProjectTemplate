#' @describeIn preinstalled.readers Read a Systat file with a \code{.sys} or \code{.syd} file extension.
systat.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.systat(filename),
         envir = .TargetEnv)
}
