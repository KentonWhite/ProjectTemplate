#' Read a semicolon separated values (.csv2) file using R's read.csv2().
#'
#' This function will load a data set stored in the CSV file format, where
#' the decimal separator is ',' and the field separator is ';', e.g. due to 
#' localized exports of dutch, german or swedish data, into the specified
#' global variable binding.
#'
#' Note: Before June 2017, the reader for .csv2 files assumed the field
#' separator to be ';' and the decimal separator to be '.'. Nowadays, R's
#' read.csv2() function is used.
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
#' \dontrun{csv2.reader('example.csv2', 'data/example.csv2', 'example')}
#' @importFrom utils read.csv
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
