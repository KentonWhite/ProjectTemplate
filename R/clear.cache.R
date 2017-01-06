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
        
        project_name <- .stopifnotproject("Change to a valid ProjectTemplate directory and run clear.cache() again.")
        
        message(paste0("Clearing cache for project: ", project_name))
        
        # ensure names or character strings are passed in ...
        dots <- match.call(expand.dots = FALSE)$...
        if (length(dots) && !all(vapply(dots, function(x) is.symbol(x) || 
                                        is.character(x), NA, USE.NAMES = FALSE))) 
                stop("... must contain names or character strings")
        variables <- vapply(dots, as.character, "")
        
        files<-c()
        
        #if no argument, then select everything in the cache 
        if (length(variables)==0) {
                # Get the variable names
                variables <- gsub(".RData","",list.files(.cache.dir, pattern="RData"))
                # get the list of files to delete
                files <- list.files(.cache.dir, pattern="RData|hash")
        }
        else {
                for (var in variables){
                        files<-c(files, paste0(var, ".RData"))
                        files<-c(files, paste0(var, ".hash"))
                }
        }
        
        # Clear the variables from memory (needs to be one at a time)
        for (v in variables) {
                args <- list(v, force=TRUE)
                suppressMessages(do.call(clear, args=args ))
        }
        
        # List of files to delete
        files_to_delete <-file.path(rep(.cache.dir, length(files)), files)
        
        # Delete them
        success <- suppressWarnings(do.call(file.remove,list(files_to_delete)))
        
        if (sum(success)!=length(success)) {
                message("Unable to remove all from cache\n")
        }
        else {
                message("Removed successfully from cache\n")
        }
}

