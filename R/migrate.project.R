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
  warnings_encountered <- NULL
  
  
  # Flags stored in environment env
  env <- environment()
  
  
  # Detect any conflicts with the old config file (flag for now and process later on)
  tryCatch(config <- .load.config(),
                      warning=function(w) {
                          # set up some variables to help process the 
                          # migration warnings later
                          assign("config_conflicts", TRUE, envir = env)
                          assign("warnings_encountered", w, envir = env)
                               
                          # specific config item flags can be added here

                      })
          
  # Detect other migration issues 
  
  

  # Exit if everything up to date
  if ((
          .check.version(config, warn.migrate = FALSE) == 0) 
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
                  "Your existing project configuration in globals.dcf does not contain the",
                  "new configuration settings in this version of ProjectTemplate.  They will",
                  "be added automatically during migration, but you should review afterward."
                  ),
                  collapse="\n"))
          
          
          # Specific logic here for new config items
          
          
          
          message(paste0(c(
                  "\n",
                  "The following warnings were detected with your configuration prior to migration:",
                  "\n"
          ),
          collapse="\n"))
          
          sapply(warnings_encountered, warning)
          
          
  }
  
  # Process other migration conflicts
  
  
  
  # save the configuration
  .save.config(config)
}


# save config and update package version
.save.config <- function (config) {
        config$version <- .package.version()
        write.dcf(config, .config.path)
        
}
