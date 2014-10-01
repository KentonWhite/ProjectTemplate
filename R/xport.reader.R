#' Read an XPort file with a .xport file extension.
#'
#' This function will load the specified XPort file into memory.
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
#' \dontrun{xport.reader('example.xport', 'data/example.xport', 'example')}
xport.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.xport(filename),
         envir = .TargetEnv)
}
