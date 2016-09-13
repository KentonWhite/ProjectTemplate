#' Add project specific config to the global config
#'
#' Enables project specific configuation to be added to the global config object
#'
#' @param ... A series of key-value pairs containing the configuration.  The key is the
#'            name that gets added to the config object.
#'
#
#' @return NULL
#'
#' @export
#' @examples
#' library('ProjectTemplate')
#' \dontrun{
#' create.config(
#'     keep_bigdata=TRUE,     # Whether to keep the big data file in memory
#'     parse=7                # number of fields to parse 
#' )
#' }
create.config <- function(...){
        project_config <- list(...)
        config <- get('config', envir = .TargetEnv)
        assign('config', c(config, project_config), envir = .TargetEnv)
}


