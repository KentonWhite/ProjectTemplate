#' @describeIn preinstalled.readers Read the RDS file format from files with the
#'   \code{.rds} extension.
#'
#' @include add.extension.R
rds.reader <- function(filename, variable.name, ...) {
  assign(variable.name,
         readRDS(filename, ...),
         envir = .TargetEnv)
}

.add.extension('rds', rds.reader)
