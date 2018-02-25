#' Read a DCF file into an R list.
#'
#' This function will read a DCF file and translate the resulting
#' data frame into a list. The DCF format is used throughout ProjectTemplate
#' for configuration settings and ad hoc file format specifications.
#' 
#' The content of the DCF file are stored as character strings.  If the content
#' is placed between the back tick character , then the content is 
#' evaluated as R code and the result returned in a string
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
#' @importFrom stats setNames
translate.dcf <- function(filename)
{
  settings <- read.dcf(filename)
  settings <- setNames(as.list(as.character(settings)), colnames(settings))
  
  # Check each setting to see if it contains R code
  for (s in names(settings)) {
          value <- settings[[s]]
          r_code <- gsub("^`(.*)`$", "\\1", value)
          if (nchar(r_code) != nchar(value)) {
                  settings[[s]] <- eval(parse(text=r_code))
          }
  }
  settings
}

