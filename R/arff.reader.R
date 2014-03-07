#' Read the Weka file format.
#'
#' This function will load a data set stored in the Weka file format into
#' the specified global variable binding.
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
#' \dontrun{arff.reader('example.arff', 'data/example.arff', 'example')}
arff.reader <- function(data.file, filename, variable.name, envir = .GlobalEnv)
{
  require.package('foreign')

  assign(variable.name,
         read.arff(filename),
         envir = envir)
}
