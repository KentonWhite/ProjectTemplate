#' Read a semicolon separated values (.csv2) file.
#'
#' This function will load a data set stored in the CSV2 file format into
#' the specified global variable binding. The default behaviour will soon
#' change to actually use R's read.csv2() function, assuming dec=".", sep=";".
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
  warning("csv2.reader's currently does not use R's read.csv2(), but will do so in the near future. (Background: Currently csv2.reader() assumes ';' as a field separator, but still assumes '.' as a decimal separator where a ',' would be expected.)");

  if (grepl('\\.zip$', filename))
  {
    tmp.dir <- tempdir()
    tmp.path <- file.path(tmp.dir, data.file)
    file.copy(filename, tmp.path)
    unzip(filename, exdir = tmp.dir)
    filename <- file.path(tmp.dir, sub('\\.zip$', '', data.file))
  }

  assign(variable.name,
         read.csv(filename,
                  header = config$data_loading_header,
                  sep = ';'),
         envir = .TargetEnv)
}
