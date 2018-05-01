#' @describeIn preinstalled.readers Read an XPort file with a \code{.xport} file extension.
xport.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.xport(filename),
         envir = .TargetEnv)
}
