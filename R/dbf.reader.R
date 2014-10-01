#' Read an XBASE file with a .dbf file extension.
#'
#' This function will load all of the data sets stored in the specified
#' XBASE file into the global environment.
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{dbf.reader('example.dbf', 'data/example.dbf', 'example')}
dbf.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.dbf(filename),
         envir = .TargetEnv)
}
