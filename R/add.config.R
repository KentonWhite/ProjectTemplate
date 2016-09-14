#' Add project specific config to the global config
#'
#' Enables project specific configuation to be added to the global config object.  The
#' allowable format is key value pairs which are appended to the end of the \code{config}
#' object, which is accessible from the global environment.
#' 
#' Once defined, the value can be accessed from any \code{ProjectTemplate} script by
#' referencing \code{config$my_project_var}.
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
#' add.config(
#'     keep_bigdata=TRUE,     # Whether to keep the big data file in memory
#'     parse=7                # number of fields to parse 
#' )
#' 
#' if (config$keep_bigdata) ...
#' }
add.config <- function(...){
        project_config <- list(...)
        config <- get('config', envir = .TargetEnv)
        assign('config', c(config, project_config), envir = .TargetEnv)
}


