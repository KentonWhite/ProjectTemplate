#' @describeIn preinstalled.readers Read a feather file in Apache Arrow format
#'   with a \code{.feather} file extension.
#'
#' @include add.extension.R
feather.reader <- function(filename, variable.name, ...) {
  .require.package('feather')

  opts = list(...)
  if ("columns" %in% opts) {
    columns <- strsplit(opts$columns, "\\s*,\\s*")[[1]]
  } else {
    columns <- NULL
  }
  assign(variable.name,
         feather::read_feather(filename, columns = columns),
         envir = .TargetEnv)
}

.add.extension("feather", feather.reader)
