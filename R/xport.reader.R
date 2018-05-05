#' @describeIn preinstalled.readers Read an XPort file with a \code{.xport} file
#'   extension.
#'
#' @include add.extension.R
xport.reader <- function(filename, variable.name, ...) {
  .require.package('foreign')

  assign(variable.name,
         foreign::read.xport(filename),
         envir = .TargetEnv)
}

.add.extension("sas", xport.reader)
.add.extension("xport", xport.reader)
.add.extension("xpt", xport.reader)
