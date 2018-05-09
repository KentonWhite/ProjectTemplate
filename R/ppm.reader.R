#' @describeIn preinstalled.readers Read a PPM file with a \code{.ppm} file extension.
#'
#' Data is loaded using the \code{pixmap::read.pnm} function.
#'
#' @include add.extension.R
ppm.reader <- function(filename, variable.name, ...) {
  .require.package('pixmap')

  assign(variable.name,
         pixmap::read.pnm(filename, ...),
         envir = .TargetEnv)
}

.add.extension("ppm", ppm.reader)
