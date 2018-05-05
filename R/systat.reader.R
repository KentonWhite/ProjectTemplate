#' @describeIn preinstalled.readers Read a Systat file with a \code{.sys} or
#'   \code{.syd} file extension.
#'
#' @include add.extension.R
systat.reader <- function(filename, variable.name, ...) {
  .require.package('foreign')

  assign(variable.name,
         foreign::read.systat(filename),
         envir = .TargetEnv)
}

.add.extension("sys", systat.reader)
.add.extension("syd", systat.reader)
