#' @describeIn preinstalled.readers Read a Minitab Portable Worksheet with a
#'   \code{.mtp3} file extension.
#'
#' @include add.extension.R
mtp.reader <- function(filename, variable.name, ...) {
  .require.package('foreign')

  assign(variable.name,
         foreign::read.mtp(filename),
         envir = .TargetEnv)
}

.add.extension("mtp", mtp.reader)
