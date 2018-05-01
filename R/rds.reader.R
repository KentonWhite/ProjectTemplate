#' @describeIn preinstalled.readers Read the RDS file format from files with the \code{.rds} extension.
rds.reader <- function(data.file, filename, variable.name) {
  assign(variable.name,
         readRDS(filename),
         envir = .TargetEnv)
}
