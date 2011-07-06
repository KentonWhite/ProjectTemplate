#' Read an XPort file with a .xport file extension.
#'
#' This function will load the specified XPort file into memory.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' xport.reader('example.xport', 'data/example.xport', 'example')
xport.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.xport(filename),
         envir = .GlobalEnv)
}
