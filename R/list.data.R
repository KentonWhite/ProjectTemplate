#' Listing the data for the current project
#'
#' This function produces a data.frame of all data files in the project, with
#'   the following meta data:
#'
#' @param override.config Named list, allows overriding individual configuration
#'   items.
#'
#' @return df data.frame containing available data with relevant meta data
#'
#' @export
#'
#' @seealso \code{\link{load.project}}, \code{\link{show.project}},
#'    \code{\link{project.config}}
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{list.data()}
list.data <- function(override.config = NULL) {
  df <- data.frame(filename = "", stringsAsFactors = FALSE)
  df
}
