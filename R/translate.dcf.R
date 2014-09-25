#' Read a DCF file into an R list.
#'
#' This function will read a DCF file and translate the resulting
#' data frame into a list. The DCF format is used throughout ProjectTemplate
#' for configuration settings and ad hoc file format specifications.
#'
#' @param filename A character vector specifying the DCF file to be
#'   translated.
#'
#' @return Returns a list containing the entries from the DCF file.
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{translate.dcf(file.path('config', 'global.dcf'))}
translate.dcf <- function(filename)
{
  settings <- read.dcf(filename)
  setNames(as.list(as.character(settings)), colnames(settings))
}
