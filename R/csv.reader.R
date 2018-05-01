#' @describeIn preinstalled.readers Read a comma separated values file with the \code{.csv} extension.
#' @importFrom utils read.csv
#' @importFrom utils unzip
csv.reader <- function(data.file, filename, variable.name)
{
  if (grepl('\\.zip$', filename))
  {
    tmp.dir <- tempdir()
    tmp.path <- file.path(tmp.dir, data.file)
    file.copy(filename, tmp.path)
    unzip(filename, exdir = tmp.dir)
    filename <- file.path(tmp.dir, sub('\\.zip$', '', data.file))
  }

  config <- get('config', .TargetEnv)
  assign(variable.name,
         read.csv(filename,
                  header = config$data_loading_header,
                  sep = ','),
         envir = .TargetEnv)
}
