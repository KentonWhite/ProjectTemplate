#' ProjectTemplate Configuration file
#'
#' Every \code{ProjectTemplate} project has a configuration file found at
#' \code{config/global.dcf} that contains various options that can be tweaked
#' to control runtime behaviour.  The valid options are shown below, and must
#' be encoded using the \code{DCF} format.
#' 
#' @param data_loading This can be set to 'on' or 'off'. If data_loading is on,
#'  the system will load data from both the cache and data directories with 
#'  cache taking precedence in the case of name conflict. By default, 
#'  data_loading is on.
#' @param cache_loading This can be set to 'on' or 'off'. If cache_loading is on,
#'  the system will load data from the cache directory before any attempt to load 
#'  from the data directory. By default, cache_loading is on.
#' @param recursive_loading This can be set to 'on' or 'off'. If recursive_loading
#'  is on, the system will load data from the data directory and all its sub 
#'  directories recursively. By default, recursive_loading is off.
#' @param munging  This can be set to 'on' or 'off'. If munging is on, the system
#'  will execute the files in the munge directory sequentially using the order 
#'  implied by the sort() function. If munging is off, none of the files in the
#'   munge directory will be executed. By default, munging is on.
#' @param logging This can be set to 'on' or 'off'. If logging is on, a logger 
#' object using the log4r package is automatically created when you run 
#' load.project(). This logger will write to the logs directory. By default, 
#' logging is off
#' @param logging_level The value of logging_level is passed to  a logger object 
#' using the log4r package during logging when when you run load.project().  By 
#' default, logging is INFO.
#' @param load_libraries This can be set to 'on' or 'off'. If load_libraries is on,
#'  the system will load all of the R packages listed in the libraries field 
#'  described below. By default, load_libraries is off.
#' @param libraries This is a comma separated list of all the R packages that the user
#'  wants to automatically load when load.project() is called. These packages must 
#'  already be installed before calling load.project(). By default, the reshape, 
#'  plyr, ggplot2, stringr and lubridate packages are included in this list.
#' @param as_factors This can be set to 'on' or 'off'. If as_factors is on, the system
#'  will convert every character vector into a factor when creating data frames; most 
#'  importantly, this automatic conversion occurs when reading in data automatically. 
#'  If 'off', character vectors will remain character vectors. By default, as_factors 
#'  is on.
#' @param data_tables This can be set to 'on' or 'off'. If data_tables is on, the 
#' system will convert every data set loaded from the data directory into a data.table.
#'  By default, data_tables is off.
#' @param attach_internal_libraries This can be set to 'on' or 'off'. If 
#' attach_internal_libraries is on, then every time a new package is loaded into memory 
#' during load.project() a warning will be displayed informing that has happened. By 
#' default, attach_internal_libraries is off.
#' @param cache_loaded_data This can be set to 'on' or 'off'. If cache_loaded_data is
#'  on, then data loaded from the data directory during load.project() will be 
#'  automatically cached (so it won't need to be reloaded next time load.project() 
#'  is called).  By default, cache_loaded_data is on for newly created projects.  
#'  Existing projects created without this configuration setting will default to off. 
#'   Similarly, when migrate.project() is called in those cases, the default will be off. 
#' 
#' @return  doesnt return anything
#' 
#' @details  If the target directory does not exist, it is created.  Otherwise,
#'   it can only contain files and directories allowed by the merge strategy.
#'
#' @seealso \code{\link{load.project}}, \code{\link{get.project}},
#'   \code{\link{cache.project}}, \code{\link{show.project}}
project.config <- NULL




#' Default configuration
#'
#' This list stores the configuration used for missing items
#' in the configuration of the current project.
#'
#' @include translate.dcf.R
#default.config


#' Configuration for new projects
#'
#' This list stores the configuration used for new projects.
#'
#' @include translate.dcf.R
#new.config 

