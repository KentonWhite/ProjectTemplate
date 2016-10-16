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
  # should be fixed (missing files, missing config item)
  # Also flag up if any items need special handling during migration (for example
  # if something other than the default is appropriate for existing projects)
  
  no_config_problems <- TRUE
  warnings_encountered <- NULL
  cache_loaded_data <- NULL
  
  env <- environment()
  
  config <- tryCatch(.load.config(),
                     warning=function(w) {
                       # set up some variables to help process the migration warnings
                       assign("no_config_problems", FALSE, envir = env)
                       assign("warnings_encountered", w, envir = env)
                       assign("cache_loaded_data", FALSE, envir = env)
                       
                       # specific config item migration can be added here
                       if (any(grepl("cache_loaded_data", w))) {
                               assign("cache_loaded_data", TRUE, envir = env)
                               
                       }
                             
                       # re-run to get the config, this time without warnings
                       return(suppressWarnings(.load.config()))
                     })
           

  if ((.check.version(config, warn.migrate = FALSE) == 0) && no_config_problems) {
    message("Already up to date.")
    return(invisible(NULL))
  }
  
  if (!no_config_problems) {
          # Tell the user about problems with their old config
          
          message(paste0(c(
                  "Your existing project configuration in globals.dcf does not contain the",
                  "new configuration settings in this version of ProjectTemplate.  They will",
                  "be added automatically during migration, but you should review afterward."
                  ),
                  collapse="\n"))
          
          
          # Specific logic here for new config
          
          if (cache_loaded_data) {
                  # switch the setting to FALSE so as to not mess up any existing
                  # munge script, but warn the user
                  config$cache_loaded_data <- FALSE
                  message(paste0(c(
                          "\n",
                          "There is a new config item called cache_loaded_data which auto-caches data",
                          "after it has been loaded from the data directory.  This has been switched",
                          "off for this project in case it breaks your scripts.  However you can switch",
                          "it on manually by editing global.dcf"),
                          collapse="\n"))
          }
          
          message(paste0(c(
                  "\n",
                  "The following warnings were detected with your configuration prior to migration:",
                  "\n"
          ),
          collapse="\n"))
          
          sapply(warnings_encountered, warning)
          
          
  }

  config$version <- .package.version()
  write.dcf(config, 'config/global.dcf')

}
