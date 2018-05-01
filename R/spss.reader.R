#' @describeIn preinstalled.readers Read an SPSS file with a \code{.sav} file extension.
#'
#' This function will load the specified SPSS file into memory. It will
#' convert the resulting list object into a data frame before inserting the
#' data set into the global environment.
spss.reader <- function(data.file, filename, variable.name)
{
  .require.package('foreign')

  assign(variable.name,
         foreign::read.spss(filename, to.data.frame = TRUE),
         envir = .TargetEnv)
}
