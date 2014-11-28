#' Read a Stata file with a .stata file extension.
#'
#' This function will load the specified Stata file into memory.
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
#' \dontrun{stata.reader('example.stata', 'data/example.stata', 'example')}
stata.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.dta(filename),
         envir = .TargetEnv)
}
