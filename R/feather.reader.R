#' @describeIn preinstalled.readers Read a feather file in Apache Arrow format with a \code{.feather} file extension.
feather.reader <- function(data.file, filename, variable.name)
{
  .require.package('feather')

  assign(variable.name,
         feather::read_feather(filename),
         envir = .TargetEnv)
}
