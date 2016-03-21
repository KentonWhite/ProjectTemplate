#' Create a concatenated string from an R list.
#'
#' This creates a list separated by the specified \code{sepchar}, which is
#' useful for specifying \code{\link{sql.reader}} odbc connections which need a
#' concatenated string separated by a semi-colon. It ignores list elements that
#' are blank. It means that the \code{sql.reader} functions can be more flexible
#' when reading .sql dcf files, as the user can specify the inputs for
#' \code{\link[RODBC]{odbcDriverConnect}}.
#'
#' @usage separated.list(target.list, ignore = NULL,sepchar = "=", colchar =
#'   ";")
#'
#' @param sepchar This is the character with which you wish to separate the list
#'   element names and the list elements.
#' @param colchar A character to collapse the list, as in \code{paste}
#' @param target.list This is a list to be concatenated. It is in the form of
#'   the information translated from a .dcf file using
#'   \code{\link{translate.dcf}}
#' @param ignore This is an optional character vector to ignore particular
#'   elements in the list.
#'
#' @return Returns a string with the list element name and list element value
#'   connected together with a separating character. These elements are then
#'   separated from all the list element blocks with a specified character.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{
#'  separated.list(
#'    target.list = database.info,
#'    ignore = c("ridiculousoption"),
#'    sepchar = "=", colchar = ";"
#'    )
#'    }
#'
#' @seealso \code{\link[ProjectTemplate]{sql.reader}} for useage and
#'   \code{\link[ProjectTemplate]{translate.dcf}} for \code{database.info} form.
#'
#'

separated.list <-
  function(target.list,
           ignore = NULL,
           sepchar = "=",
           colchar = ";") {
    # look in the field, if blank return nothing else
    # return string in form: "field=target.list['field'];"
    input_list <- names(target.list)
    input_list <- input_list[which(!(input_list %in% ignore))]

    config_param <-
      paste(input_list,
            colchar,
            target.list[input_list],
            sep = "",
            collapse = sepchar)

    config_param

  }
