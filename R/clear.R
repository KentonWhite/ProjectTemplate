#' Clear objects from the global environment
#' 
#' This function removes specific (or all by default) named objects from the global
#' environment.  If used within a \code{ProjectTemplate} project, then any variables 
#' defined in the \code{config$sticky_variables} will remain.
#'
#' @param ... A sequence of character strings  of the objects to
#'  be removed from the global environment.  If none given, then all items except
#'  those in \code{keep} will be deleted.
#' @param keep A character vector of variables that should remain in the global
#'  environment
#' @param force If \code{TRUE}, then variables will be deleted even if 
#'  specifed in \code{keep} or \code{config$sticky_variables} 
#' 
#' @return The variables kept and removed are reported
#'
#' @export
#' @examples
#' library('ProjectTemplate')
#' \dontrun{
#' clear("x", "y", "z")
#' clear(keep="a")
#' clear()
#' }
clear <- function (..., keep=c(), force=FALSE) {
        
        # ensure names or character strings are passed in ...
        dots <- match.call(expand.dots = FALSE)$...
        if (length(dots) && !all(vapply(dots, function(x) is.symbol(x) || 
                                        is.character(x), NA, USE.NAMES = FALSE))) 
                stop("... must contain names or character strings")
        names <- vapply(dots, as.character, "")
        
        # If no ... specified, get everything from global environment
        if (length(names) == 0L) 
                names <- ls(envir = .TargetEnv)
        
        # Remove any that should be kept
        if(!force) names <- .remove.sticky.vars(names, keep)
        
        if (length(names) >0) {
                message(paste0("Objects to clear from memory: ",
                               paste(names, collapse = " ")))
                rm(list=names, envir = .TargetEnv)
        } else {
                message("No objects to clear")
        }
}

.remove.sticky.vars <- function (names, keep) {
        
        if (exists("config") && is.list(config) && 
            ("sticky_variables" %in% names(config)) &&
            config$sticky_variables != "NONE") {
                    keep <- c(keep, strsplit(config$sticky_variables, '\\s*,\\s*')[[1]])
        }
        if (length(keep) > 0)
                message(paste0("Variables not cleared: ", paste(keep, collapse = " ")))
                
        setdiff(names, keep)
}
