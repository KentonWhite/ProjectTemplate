#' ProjectTemplate Configuration file
#'
#' Every \code{ProjectTemplate} project has a configuration file found at
#' \code{config/global.dcf} that contains various options that can be tweaked
#' to control runtime behaviour.  The valid options are shown below, and must
#' be encoded using the \code{DCF} format.
#' 
#' Calling the \code{project.config()} function will display the current project
#' configuration.
#' 
#' 
#' @return  The current project configuration is displayed. 
#' 
#' 
#' @details The options that can be configured in the \code{config/global.dcf} are
#'  shown below
#' \tabular{ll}{
#'  \code{data_loading} \tab This can be set to 'on' or 'off'. If data_loading is on,
#'  the system will load data from both the cache and data directories with 
#'  cache taking precedence in the case of name conflict. \cr
#'  \code{cache_loading} \tab This can be set to 'on' or 'off'. If cache_loading is on,
#'  the system will load data from the cache directory before any attempt to load 
#'  from the data directory. \cr
#'  \code{recursive_loading} \tab This can be set to 'on' or 'off'. If recursive_loading
#'  is on, the system will load data from the data directory and all its sub 
#'  directories recursively.  \cr
#'  \code{munging} \tab This can be set to 'on' or 'off'. If munging is on, the system
#'  will execute the files in the munge directory sequentially using the order 
#'  implied by the sort() function. If munging is off, none of the files in the
#'   munge directory will be executed.  \cr
#'  \code{logging} \tab This can be set to 'on' or 'off'. If logging is on, a logger 
#' object using the log4r package is automatically created when you run 
#' load.project(). This logger will write to the logs directory.  \cr
#'  \code{logging_level} \tab The value of logging_level is passed to  a logger object 
#' using the log4r package during logging when when you run load.project(). \cr
#'  \code{load_libraries} \tab  This can be set to 'on' or 'off'. If load_libraries is on,
#'  the system will load all of the R packages listed in the libraries field 
#'  described below. \cr
#'  \code{libraries} \tab This is a comma separated list of all the R packages that the user
#'  wants to automatically load when load.project() is called. These packages must 
#'  already be installed before calling load.project().  \cr
#'  \code{as_factors} \tab This can be set to 'on' or 'off'. If as_factors is on, the system
#'  will convert every character vector into a factor when creating data frames; most 
#'  importantly, this automatic conversion occurs when reading in data automatically. 
#'  If 'off', character vectors will remain character vectors. \cr
#'  \code{data_tables} \tab This can be set to 'on' or 'off'. If data_tables is on, the 
#' system will convert every data set loaded from the data directory into a data.table. \cr
#'  \code{attach_internal_libraries} \tab This can be set to 'on' or 'off'. If 
#' attach_internal_libraries is on, then every time a new package is loaded into memory 
#' during load.project() a warning will be displayed informing that has happened. \cr
#'  \code{cache_loaded_data} \tab This can be set to 'on' or 'off'. If cache_loaded_data is
#'  on, then data loaded from the data directory during load.project() will be 
#'  automatically cached (so it won't need to be reloaded next time load.project() 
#'  is called). \cr
#' \code{sticky_variables} \tab This is a comma separated list of any project-specific
#'   variables that should remain in the global environment after a \code{clear()} command. 
#'    This can be used to clear the global environment, but keep any large datasets in 
#'    place so they are not unnecessarily re-generated during \code{load.project()}.  
#'    Note that any this will be over-ridden if the \code{force=TRUE} parameter is passed
#'     to \code{clear()}`.  \cr
#'  }
#'  
#'    If the \code{config/globals.dcf} is missing some items (for example because it was created under an
#' old version of \code{ProjectTemplate}, then the following configuration is used for any missing items
#' during \code{load.project()}:
#'   \Sexpr[results=rd, stage=build]{ProjectTemplate:::.format.config(ProjectTemplate:::.default.config[-1], format="Rd")}
#'
#'  When a new project is created using \code{create.project()}, the following values are pre-populated:
#'   \Sexpr[results=rd, stage=build]{ProjectTemplate:::.format.config(ProjectTemplate:::.new.config, format="Rd")}
#'
#' @export
#' 
#' 
#'     
#' @seealso \code{\link{load.project}}
project.config <- function () {
        
        project_name <- .stopifnotproject("Please change to correct directory and re-run project.config()")
        message(paste0("Configuration for project: ", project_name))
        
        # get the config first from config/globals.dcf
        config_file <- .read.config()
        message(.format.config(config_file))
        
        # Check if there is custom config added by add.config calls
        if (exists("config")) {
                config <- get("config", envir = .TargetEnv)
                additional_config <- setdiff(names(config), names(config_file))
                if (length(additional_config) > 0) {
                        message("\nAdditional custom config present for this project:")
                        message(.format.config(config[!(names(config) %in% names(config_file))]))
                }
        }
}
