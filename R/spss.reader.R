#' Read an SPSS file with a .sav file extension.
#'
#' This function will load the specified SPSS file into memory. It will
#' convert the resulting list object into a data frame before inserting the
#' data set into the global environment.
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
#' #spss.reader('example.sav', 'data/example.sav', 'example')
spss.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  #assign(variable.name,
  #       read.spss(filename),
  #       envir = .GlobalEnv)

  assign(variable.name,
         as.data.frame(read.spss(filename)),
         envir = .GlobalEnv)
}
