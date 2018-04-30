#' Read the feather file format.
#'
#' This function will load a data set stored in the feather file format into
#' the specified global variable binding.
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' \dontrun{feather.reader('example.feather', 'data/example.feather', 'example')}
feather.reader <- function(data.file, filename, variable.name)
{
  .require.package('feather')

  assign(variable.name,
         feather::read_feather(filename),
         envir = .TargetEnv)
}
