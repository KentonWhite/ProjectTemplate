# This file contains internal helper functions to determine whether a given path is a ProjectTemplate directory
# or not.

# The purpose is to allow user functions (load.project etc) to exit cleanly rather than try and perform their
# function when it's not appropriate
#
# main functions are:
#       .stopifnotproject()  which will stop if the path is not a ProjectTemplate
#       .stopifproject()  which will stop if the path is a ProjectTemplate
#
# It is intended that user functions will call one of these as appropriate near the beginning of their 
# execution and they can supply an additional message to display to the user to tell them how to rectify
# the situation which caused their command to stop
#

# files that determine whether a directory is a ProjectTemplate project
.mandatory.files <- c("config/global.dcf", "cache", "data")

# Test whether a given path is a ProjectTemplate project
.is.ProjectTemplate <- function (path=getwd()) {
        check_files <- file.path(path, .mandatory.files)
        if(sum(file.exists(check_files))==length(check_files)) return(TRUE)
        return(FALSE)
}




# Function to stop processing if the path is not a Project Template
# return the project name if it is a Project Template directory
.stopifnotproject <- function(additional_message="", path=getwd()) {
        
        is.ProjectTemplate <- .is.ProjectTemplate(path)
        
        if (!is.ProjectTemplate) {
                directory <- ifelse(path==getwd(), "Current Directory: ", "Directory: ")
                
                message(
                        paste0(c(paste0(directory, basename(path),
                                        " is not a ProjectTemplate directory"),
                                 additional_message),
                               sep = "\n")
                )
                
                .quietstop()
        }
        basename(path)
}

# Function to stop processing if the path is a Project Template
.stopifproject <- function(additional_message="", path=getwd()) {
        
        is.ProjectTemplate <- .is.ProjectTemplate(path)
        
        if (is.ProjectTemplate) {
                directory <- ifelse(path==getwd(), "Current Directory: ", "Directory: ")
                
                message(
                        paste0(c(paste0(directory, basename(path),
                                        " is a ProjectTemplate directory"),
                                 additional_message),
                               collapse = "\n")
                )
                
                .quietstop()
        }
}

# stop silently
.quietstop <- function () {
        
        few <- options(show.error.messages=FALSE)
        on.exit(options(few))
        stop()
}

