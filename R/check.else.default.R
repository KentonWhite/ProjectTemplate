#' Check for a value in a list else return the default
#'
#' Designed for use with \code{sql.reader} to return the relevant variable where
#' it has been declared in a list. This is necessary as often 'NULL' will be a
#' valid argument in a function, but the value returned if a declared element is
#' not in a list is null (i.e. \code{somelist[['elementnotinlist']]} =
#' \code{NULL}).
#'
#' @usage check.else.default(arg, default, options)
#'
#' @param arg String specifying the list element name you are looking for.
#' @param default The default list. Value returned where no match is found in
#'   the \code{options} variable with list elements in \code{options}.
#' @param options The options list. Value return where there is a match with the
#'   \code{arg} variable and one of the list elements.
#'
#' @return Value of the named list element.
#'
#' @examples
#' library(ProjectTemplate)
#'
#' \dontrun{a <- formals(lm) # a 'default' list
#'          b <- list(qr = FALSE) # list where arg 'qr' is declared
#'          check.else.default(arg = 'qr', default = a, options = b)}
#'
#' @seealso \code{\link{sql.reader}}
#'
check.else.default <- function(arg, default, options){

  if(exists(arg, where = options)) {
    return(options[[arg]])
  } else {
    return(default[[arg]])
  }

}
