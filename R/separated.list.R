#' Create a separated list where some vars are blank
#'
#' This creates a list separated by the specified \code{sep}. It ignores
#' vars that are blank, which is useful for specifying sql.reader functions
#' which often create a concatenated string. It means that the sql.reader
#' functions can be more flexible when reading .sql files.
#'
#' @param ... these are all the params to be passed to RODBC
#' @param sepchar this is the value you wish to separate the files with
#' @param database.info this is a list of the information translated from
#'  the relevant .dcf file
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{
#'  a <- "username"
#'  b <- "password"
#'  d <- "notinthelist"
#'  e <- NA
#'  f <- NULL
#'
#'  database.info <- list(somedcfoutput...)
#'
#'  separated.list(sep = ";", a, b, d)}
#'

separated.list <- function(sepchar = ";", database.info, ...){
  # look in the field, if blank return nothing else
  # return string in form: "field=database.info[['field']];"
  input_list <- list(...)
  input_list <- unlist(input_list[which(input_list != "")])
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
