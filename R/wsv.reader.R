#' @describeIn preinstalled.readers Read a whitespace separated values file with
#'   the \code{.wsv} or \code{.txt} file extensions.
#'
#' @importFrom utils read.table
#' @importFrom utils unzip
#'
#' @include add.extension.R
wsv.reader <- function(filename, variable.name, ...) {
  if (grepl('\\.zip$', filename))
  {
    tmp.dir <- tempdir()
    tmp.path <- file.path(tmp.dir, basename(filename))
    file.copy(filename, tmp.path)
    unzip(filename, exdir = tmp.dir)
    filename <- file.path(tmp.dir, sub('\\.zip$', '', basename(filename)))
  }

  assign(variable.name,
         read.table(filename,
                  header = config$data_loading_header),
         envir = .TargetEnv)
}

.add.extension("wsv", wsv.reader)
.add.extension("wsv.bz2", wsv.reader)
.add.extension("wsv.zip", wsv.reader)
.add.extension("wsv.gz", wsv.reader)
.add.extension("txt", wsv.reader)
.add.extension("txt.bz2", wsv.reader)
.add.extension("txt.zip", wsv.reader)
.add.extension("txt.gz", wsv.reader)
.add.extension("dat", wsv.reader)
.add.extension("dat.bz2", wsv.reader)
.add.extension("dat.zip", wsv.reader)
.add.extension("dat.gz", wsv.reader)
