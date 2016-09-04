#' Clear data sets from the cache.
#'
#' This function remove specific (or all by default) named data sets from the \code{cache}
#' directory. This will force that data to be read in from the \code{data} directory
#' next time \code{\link{load.project}} is called. 
#'
#' @param variables A character vector containing the name of the variable to
#'  be removed from the cache.
#'
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#' @examples
#' library('ProjectTemplate')
#' \dontrun{clear.cache()}
#'
#' 
clear.cache <- function (variables=NULL){
        cache_dir <- "./cache"
        
        #if no argument, then select everything in the cache 
        if (is.null(variables)) {
                files <- list.files(cache_dir)
        }
        else {
                # Add the .RData cache extension to the objects to delete
                files <- paste0(variables, rep(".RData", length(variables)))
        }
        
        # List of files to delete
        files_to_delete <-file.path(rep(cache_dir, length(files)), files)
        
        # Delete them
        sucess <- do.call(file.remove,list(files_to_delete))
        if (sucess) {
                message(paste0("Removed ", variables, " from cache"))
        }
        else {
                message(paste0("Unable to remove ", variables, " from cache"))
        }
}

