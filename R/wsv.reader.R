#' @describeIn preinstalled.readers Read a whitespace separated values file with the \code{.wsv} or \code{.txt} file extensions.
#' @importFrom utils read.table
#' @importFrom utils unzip
wsv.reader <- function(data.file, filename, variable.name)
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
         read.table(filename,
                  header = config$data_loading_header),
         envir = .TargetEnv)
}
