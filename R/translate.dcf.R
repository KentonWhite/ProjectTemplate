#' Read a DCF file into an R data frame.
#'
#' This function will read a DCF file and translate the resulting
#' list into a data frame. The DCF format is used throughout ProjectTemplate.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' translate.dcf('config/global.dcf')
translate.dcf <- function(filename)
{
  settings <- read.dcf(filename)

  tmp <- list()

  for (name in colnames(settings))
  {
    tmp[[name]] <- as.character(settings[1, name])
  }

  return(tmp)
}
