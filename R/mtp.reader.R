#' @describeIn preinstalled.readers Read a Minitab Portable Worksheet with a \code{.mtp3} file extension.
mtp.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.mtp(filename),
         envir = .TargetEnv)
}
