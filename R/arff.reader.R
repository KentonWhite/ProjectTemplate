#' Read the Weka (.arff) file format.
#'
#' This function will load a data set stored in the Weka file format into
#' the specified global variable binding.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' arff.reader('example.arff', 'data/example.arff', 'example')
arff.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.arff(filename),
         envir = .GlobalEnv)
}
