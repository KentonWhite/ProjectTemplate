#' @describeIn preinstalled.readers Read a semicolon separated values file with the \code{.csv2} extension.
#'
#' In May 2018, the default behaviour of the reader for .csv2 files changed to use R's read.csv2(),
#' where the field separator is assumed to be ';' and the decimal separator to be ','.
#'
#' @importFrom utils read.csv2
#' @importFrom utils unzip
csv2.reader <- function(data.file, filename, variable.name)
{
  warning("In May 2018, the default behaviour of the reader for .csv2 files changed to use R's read.csv2(), where the field separator is assumed to be ';' and the decimal separator to be ','.")

  if (grepl('\\.zip$', filename))
  {
    tmp.dir <- tempdir()
    tmp.path <- file.path(tmp.dir, data.file)
    file.copy(filename, tmp.path)
    unzip(filename, exdir = tmp.dir)
    filename <- file.path(tmp.dir, sub('\\.zip$', '', data.file))
  }

  assign(variable.name,
         read.csv2(filename,
                  header = config$data_loading_header),
         envir = .TargetEnv)
}
