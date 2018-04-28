#' @describeIn preinstalled.readers Read a PPM file with a \code{.ppm} file extension.
#'
#' Data is loaded using the \code{pixmap::read.pnm} function.
ppm.reader <- function(data.file, filename, variable.name)
{
  .require.package('pixmap')

  assign(variable.name,
         pixmap::read.pnm(filename),
         envir = .TargetEnv)
}
