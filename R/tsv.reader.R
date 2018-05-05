#' @describeIn preinstalled.readers Read a tab separated values file with the
#'   \code{.tsv} or \code{.tab} file extensions.
#'
#' @importFrom utils read.csv
#' @importFrom utils unzip
#'
#' @include add.extension.R
tsv.reader <- function(filename, variable.name, ...) {
  if (grepl('\\.zip$', filename))
  {
    tmp.dir <- tempdir()
    tmp.path <- file.path(tmp.dir, basename(filename))
    file.copy(filename, tmp.path)
    unzip(filename, exdir = tmp.dir)
    filename <- file.path(tmp.dir, sub('\\.zip$', '', basename(filename)))
  }

  assign(variable.name,
         read.csv(filename,
                  header = config$data_loading_header,
                  sep = '\t'),
         envir = .TargetEnv)
}

.add.extension("tsv", tsv.reader)
.add.extension("tsv.bz2", tsv.reader)
.add.extension("tsv.zip", tsv.reader)
.add.extension("tsv.gz", tsv.reader)
.add.extension("tab", tsv.reader)
.add.extension("tab.bz2", tsv.reader)
.add.extension("tab.zip", tsv.reader)
.add.extension("tab.gz", tsv.reader)
