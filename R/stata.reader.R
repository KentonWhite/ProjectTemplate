#' @describeIn preinstalled.readers Read a Stata file with a \code{.dta} file
#'   extension.
#'
#' @include add.extension.R
stata.reader <- function(filename, variable.name, ...) {
  .require.package('foreign')

  assign(variable.name,
         foreign::read.dta(filename),
         envir = .TargetEnv)
}

.add.extension("dta", stata.reader)
