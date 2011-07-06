#' Read a Stata file with a .stata file extension.
#'
#' This function will load the specified Stata file into memory.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' stata.reader('example.stata', 'data/example.stata', 'example')
stata.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.dta(filename),
         envir = .GlobalEnv)
}
