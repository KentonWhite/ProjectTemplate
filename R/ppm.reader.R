#' Read a PPM file with a .ppm file extension.
#'
#' This function will load the specified PPM file into memory using the
#' pixamp package. This is useful for working with image files as a data
#' set.
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
#' \dontrun{ppm.reader('example.ppm', 'data/example.ppm', 'example')}
ppm.reader <- function(data.file, filename, variable.name)
{
  .require.package('pixmap')

  assign(variable.name,
         pixmap::read.pnm(filename),
         envir = .TargetEnv)
}
