#' @describeIn preinstalled.readers Read an XBASE file with a \code{.dbf} file extension.
#'
#' @include add.extension.R
dbf.reader <- function(filename, variable.name, ...) {
  .require.package("foreign")

  assign(variable.name,
         foreign::read.dbf(filename),
         envir = .TargetEnv)
}

.add.extension("dbf", dbf.reader)
