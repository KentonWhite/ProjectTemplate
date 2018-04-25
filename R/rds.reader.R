#' Read the RDS file format.
#'
#' This function will load a data set stored in the RDS file format into
#' the specified global variable binding.
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' \dontrun{rds.reader('example.rds', 'data/example.rds', 'example')}
rds.reader <- function(data.file, filename, variable.name) {
  assign(variable.name,
         readRDS(filename),
         envir = .TargetEnv)
}
