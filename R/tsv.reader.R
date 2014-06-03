#' Read a tab separated values (.tsv or .tab) file.
#'
#' This function will load a data set stored in the TSV file format into
#' the specified global variable binding.
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
#' \dontrun{tsv.reader('example.tsv', 'data/example.tsv', 'example')}
tsv.reader <- function(data.file, filename, variable.name)
{
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
                  header = TRUE,
                  sep = '\t'),
         envir = .TargetEnv)
}
