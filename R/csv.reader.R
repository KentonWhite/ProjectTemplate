#' @describeIn preinstalled.readers Read a comma separated values file with the \code{.csv} extension.
#' @importFrom utils read.csv
#' @importFrom utils unzip
#' @include add.extension.R
csv.reader <- function(filename, variable.name, ...) {
  if (grepl('\\.zip$', filename)) {
    tmp.dir <- tempdir()
    tmp.path <- file.path(tmp.dir, basename(filename))
    file.copy(filename, tmp.path)
    unzip(filename, exdir = tmp.dir)
    filename <- file.path(tmp.dir, sub('\\.zip$', '', basename(filename)))
  }

  config <- get('config', .TargetEnv)
  assign(variable.name,
         read.csv(filename,
                  header = config$data_loading_header,
                  sep = ',',
                  ...),
         envir = .TargetEnv)
}

.add.extension("csv", csv.reader)
.add.extension("csv.bz2", csv.reader)
.add.extension("csv.zip", csv.reader)
.add.extension("csv.gz", csv.reader)
