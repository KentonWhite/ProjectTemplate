#' Read an Epi Info file with a .rec file extension.
#'
#' This function will load all of the data sets stored in the specified 
#' Epi Info file into the global environment.
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#' @param envir The environment, defaults to the global environment.  In most
#'   use cases this parameter can be omitted.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{epiinfo.reader('example.rec', 'data/example.rec', 'example')}
epiinfo.reader <- function(data.file, filename, variable.name, envir = .GlobalEnv)
{
  require.package('foreign')

  assign(variable.name,
         read.epiinfo(filename),
         envir = envir)
}
