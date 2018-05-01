#' @describeIn preinstalled.readers Read an XBASE file with a \code{.dbf} file extension.
dbf.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.dbf(filename),
         envir = .TargetEnv)
}
