#' @describeIn preinstalled.readers Read a tab separated values file with the \code{.tsv} or \code{.tab} file extensions.
#' @importFrom utils read.csv
#' @importFrom utils unzip
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
                  header = config$data_loading_header,
                  sep = '\t'),
         envir = .TargetEnv)
}
