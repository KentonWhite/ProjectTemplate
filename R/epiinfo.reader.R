#' @describeIn preinstalled.readers Read an Epi Info file with a \code{.rec} file extension.
#'
#' @include add.extension.R
epiinfo.reader <- function(filename, variable.name, ...) {
  .require.package('foreign')

  assign(variable.name,
         foreign::read.epiinfo(filename, ...),
         envir = .TargetEnv)
}

.add.extension("rec", epiinfo.reader)
