#' Read a Systat file with a .sys or .syd file extension.
#'
#' This function will load the specified Systat file into memory.
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
#' \dontrun{systat.reader('example.sys', 'data/example.sys', 'example')}
systat.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.systat(filename),
         envir = .TargetEnv)
}
