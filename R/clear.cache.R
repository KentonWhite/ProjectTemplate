#' Clear data sets from the cache
#'
#' This function remove specific (or all by default) named data sets from the \code{cache}
#' directory. This will force that data to be read in from the \code{data} directory
#' next time \code{\link{load.project}} is called. 
#'
#' @param ... A sequence of character strings  of the variables to
#'  be removed from the cache.  If none given, then all items in the cache will be removed.
#'
#
#' @return Success or failure is reported
#'
#' @export
#' @examples
#' library('ProjectTemplate')
#' \dontrun{
#' clear.cache("x", "y", "z")
#' }
clear.cache <- function (...){
        variables <- list(...)
        cache_dir <- "./cache"
        
        files<-c()
        #if no argument, then select everything in the cache 
        if (length(variables)==0) {
                files <- list.files(cache_dir)
        }
        else {
                for (var in variables){
                        files<-c(files, paste0(var, ".RData"))
                        files<-c(files, paste0(var, ".hash"))
                }
                # Add the .RData cache extension to the objects to delete
                #files <- paste0(variables, rep("\\.RData", length(variables)))
                #files <- c(files, paste0(variables, rep("\\.hash", length(variables))))
        }
        
        # List of files to delete
        files_to_delete <-file.path(rep(cache_dir, length(files)), files)
        
        # Delete them
        success <- suppressWarnings(do.call(file.remove,list(files_to_delete)))
        
        if (sum(success)!=length(success)) {
                message("Unable to remove all from cache\n")
        }
        else {
                message("Removed successfully from cache\n")
        }
}

