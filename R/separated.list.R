#' Create a separated list where some vars are blank
#'
#' This creates a list separated by the specified \code{sepchar}. It ignores
#' vars that are blank, which is useful for specifying \code{\link{sql.reader}}
#' odbc connections which need a concatenated string separated by a semi-colon.
#' It means that the sql.reader functions can be more flexible when reading .sql
#' dcf files, as the user can specify the inputs for \code{\link{odbcDriverConnect}}.
#'
#' @param sepchar this is the character with which you wish to separate list.
#' @param database.info this is a list to be concatenated. It is in the form
#'  of the information translated from a .dcf file using \code{\link{translate.dcf}}
#' @param ignore this is an optional char var to ignore particular vars
#'  in the dcf.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{
#'  separated.list(sepchar = ";", database.info = database.info, ignore = c("ridiculousoption"))}
#'
#' @seealso \code{\link{sql.reader}} for useage and \code{\link{translate.dcf}} for
#' \code{database.info input}
#'
#' @include .require.package.R
#'

separated.list <- function(sepchar = ";", database.info, ignore){
  # look in the field, if blank return nothing else
  # return string in form: "field=database.info[['field']];"
  input_list <- names(database.info)
  output_list <- NULL

  for(i in 1:length(input_list)){
    config_param <- database.info[[input_list[i]]]
    if(is.null(config_param)){
      config_param <- NA
    }
    if(!is.na(config_param) & config_param != ""){
      inc_list <- paste(input_list[i], "=", config_param, sepchar, sep = "")
      output_list <- paste(output_list, inc_list, sep = "")
    }
  }

  return(output_list)

}
