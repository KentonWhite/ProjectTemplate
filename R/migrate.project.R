#' Migrates a project from a previous version of ProjectTemplate
#'
#' This function automatically performs all necessary steps to migrate an existing project
#' so that it is compatible with this version of ProjectTemplate
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @seealso \code{\link{create.project}}
#'
#' @include load.project.R
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{migrate.project()}
migrate.project <- function()
{
  my.project.info <- list()

  message('Migrating project configuration')

  # Load the config and look for specific problems in the configuration that
  # should be fixed (e.g. missing files, missing config item)
  # Also flag up if any items need special handling during migration (for example
  # if something other than the default is appropriate for existing projects)
  
  # Initialise migration flags
  config_conflicts <- FALSE
  config_warnings <- NULL
  
  
  # Flags stored in environment env
  env <- environment()
  
  # Detect any conflicts with the existing config file once it has been processed
  # during load.project() (flag for now and handle later on)
  
  loaded.config <- tryCatch(.load.config(),
                      warning=function(w) {
                          # set up some variables to help process the 
                          # migration warnings later
                          
                          assign("config_conflicts", TRUE, envir = env)
                          assign("config_warnings", w$message, envir = env)
                          suppressWarnings(.load.config())
                      })
          
  # Detect other migration issues 
  
  

  # Exit if everything up to date
  if ((
          .check.version(loaded.config, warn.migrate = FALSE) == 0) 
       && !config_conflicts
      ) {
          message("Already up to date.")
          return(invisible(NULL))
  }
  
  # Otherwise ....
  
  # Process config conflicts
  if (config_conflicts) {
          
          # Tell the user about problems with their old config
          
          message(paste0(c(
                  "Your existing project configuration in globals.dcf does not contain up to",
                  paste0("date configuration settings in this version ",
                  .package.version(),
                  " of ProjectTemplate.  They will"),
                  "be added automatically during migration, but you should review afterward."
                  ),
                  collapse="\n"))
          
          if(grepl("missing a configuration file", config_warnings)) {
                  message(paste0(c(
                          "You didn't have a config.dcf file.  One has been created",
                          "for you using default values"
                          ),
                  collapse="\n"))
          }
          
         
          if(grepl("missing the following entries", config_warnings)) {
                  message(paste0(c(
                          "Your config.dcf file was missing entries and defaults",
                          "have been used.  The missing entries are:"
                          ),
                  collapse="\n"))
                  missing <- sub(".*missing the following entries:([^.]*)\\.(.*)$", "\\1", config_warnings)
                  message(missing)
          }
          
          if(grepl("contains the following unused entries", config_warnings)) {
                  message(paste0(c(
                          "Your config.dcf file contained unused entries which have been",
                          "removed.  The unused entries are:"
                          ),
                  collapse="\n"))
                  unused <- sub(".*contains the following unused entries:([^.]*)\\.(.*)$", "\\1", config_warnings)
                  message(unused)
          }
          
                    
          # Specific logic here for new config items that need special migration treatment
          
          if(grepl("cache_loaded_data", config_warnings)) {
                  # switch the setting to FALSE so as to not mess up any existing
                  # munge script, but warn the user
                  loaded.config$cache_loaded_data <- FALSE
                  message(paste0(c(
                          "\n",
                          "There is a new config item called cache_loaded_data which auto-caches data",
                          "after it has been loaded from the data directory.  This has been switched",
                          "off for this project in case it breaks your scripts.  However you can switch",
                          "it on manually by editing global.dcf"),
                          collapse="\n"))
          }
          
  }
  
  # Process other migration conflicts
  
  
  
  # Finally, save the validated configuration with the updated version number
  .save.config(loaded.config)   
  
}

