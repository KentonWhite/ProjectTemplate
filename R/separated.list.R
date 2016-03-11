#' Create a concatenated string from an R list.
#'
#' This creates a list separated by the specified \code{sepchar}, which is
#' useful for specifying \code{\link{sql.reader}} odbc connections which
#' need a concatenated string separated by a semi-colon. It ignores
#' list elements that are blank.
#' It means that the \code{sql.reader} functions can be more flexible when
#' reading .sql dcf files, as the user can specify the inputs for
#' \code{\link[RODBC]{odbcDriverConnect}}.
#'
#' @param sepchar this is the character with which you wish to separate list.
#' @param target.list this is a list to be concatenated. It is in the form
#'  of the information translated from a .dcf file using
#'  \code{\link{translate.dcf}}
#' @param ignore this is an optional character vector to ignore particular
#'  elements in the list.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{
#'  separated.list(sepchar = ";",
#'    target.list = database.info,
#'    ignore = c("ridiculousoption")
#'    )
#'    }
#'
#' @seealso \code{\link[ProjectTemplate]{sql.reader}} for useage and
#' \code{\link[ProjectTemplate]{translate.dcf}} for \code{database.info} form.
#'
#'

separated.list <- function(sepchar = ";", target.list, ignore){
  # look in the field, if blank return nothing else
  # return string in form: "field=target.list[['field']];"
  input_list <- names(target.list)
  output_list <- NULL

  for(i in 1:length(input_list)){
    config_param <- target.list[[input_list[i]]]
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
