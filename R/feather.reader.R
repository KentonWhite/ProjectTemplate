#' @describeIn preinstalled.readers Read a feather file in Apache Arrow format
#'   with a \code{.feather} file extension.
#'
#' @include add.extension.R
feather.reader <- function(filename, variable.name, ...) {
  .require.package('feather')

  assign(variable.name,
         feather::read_feather(filename),
         envir = .TargetEnv)
}

.add.extension("feather", feather.reader)
