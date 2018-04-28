#' @describeIn preinstalled.readers Read an Epi Info file with a .rec file extension.
epiinfo.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.epiinfo(filename),
         envir = .TargetEnv)
}
