#' Read an XBASE file with a .dbf file extension.
#'
#' This function will load all of the data sets stored in the specified 
#' XBASE file into the global environment.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' dbf.reader('example.dbf', 'data/example.dbf', 'example')
dbf.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.dbf(filename),
         envir = .GlobalEnv)
}
