# This file has the main infrastructure for the custom template subsystem.  There 
# are no functions exported to users from here - instead the user facing functions make
# calls here

# Custom templates can be configured for each different installation of ProjectTemplate
# There can be multiple templates, and one of them is a default.  They are invoked by
#     create.project("project-name", "template name")
# or
#     create.project("project-name") to invoke the default template
#
# First of all, the standard ProjectTemplate structure is created.  Then the structure
# defined for each template name is copied into the standard structure, overwriting 
# anything already there, and adding any new files.
#
# The location of the templates is a single location on the local file system or github.
# This is called the root template location.  Each sub directory under the root 
# location is the template-name used in the call to create.project.
#

# First, Some short cut definitions to aid readability

# Where is the root template location defined
.root.template.dir <- file.path(.libPaths(), "ProjectTemplate", "defaults", "customtemplate")
.root.template.file <- file.path(.root.template.dir, "RootConfig.dcf")

# A backup is needed otherwise it will be overwritten when ProjectTemplate is updated 
.root.templatebackup.dir <- file.path(R.home(), "etc")
.root.templatebackup.file <- file.path(.root.templatebackup.dir, "ProjectTemplateRootConfig.dcf")

# allow templates to be defined in the local filesystem, or on github
.available.location.types <- c("local", "github")

# Helper function to remove the first item in a list
.remove.first <- function (x) rev(head(rev(x), -1))

# Read a template definition file and return the contents as a dataframe
.read.template.definition <- function (template.file=.get.root.location()) {
        definition <- as.data.frame(read.dcf(template.file), 
                                    stringsAsFactors = FALSE)
        invalid_types <- setdiff(definition$type, .available.location.types)
        if(length(invalid_types)>0) {
                stop(paste0("Invalid template types in ", template.file, ": ", invalid_types))
        }
        definition
}

.set.root.location <- function (location, type) {
        if (!(type %in% .available.types)) {
                message(paste0("Invalid type: ", type))
                return(invisible(NULL))
        }
        if (is.null(location)) {
                location <- "NULL"
        }
        else if (!.is.dir(location)) {
                message(paste0("Invalid template location: ", location))
                return(invisible(NULL))
        }
        
        location <- data.frame(location=location, type=type)
        write.dcf(location, .root.template.file)
        
        # Create a backup of the root location
        if(!.is.dir(.root.templatebackup.dir)) dir.create(.root.templatebackup.dir)
        write.dcf(location, .root.templatebackup.file)
}

.get.root.location <- function () {
        location <- .get.template.locations(.root.template.file)
        location <- location[1,]
        if(location$location == "NULL") return (NULL)
        location
}


.read.template.info <- function () {
        template.root <- .get.root.location()
        if (is.null(template.root)) return(NULL)
        
        # read raw template information
        if (template.root$type == "github") {
                templates <- .download.github(template.root$location)
        }
        else if (template.root$type == "local") {
                templates <- template.root$location
                sub.dirs <- list.dirs(templates)
                template.names <- basename(.remove.first(sub.dirs))
                template.info <- data.frame(
                        clean.names = sub("(.*)_default$", "\\1", 
                                          template.names),
                        default = grepl("_default$", template.names),
                        path = file.path(templates, template.names)
                )        
        }
        else {
                template.info <- NULL
        }
        if (nrow(template.info)>0){
                # sort into order - default first
                template.info <- template.info[with(template.info, 
                                                    order(-default, clean.names)),]
                # and make sure there is only one default
                template.info$default <- c(TRUE, rep(FALSE, nrow(template.info)-1))
        }
        template.info
}

.template.status <- function () {
        template.info <- .get.template.names()
        if (is.null(template.info)) {
                message <- paste0(c("Custom Templates not configured for this installation.",
                                    "Run configure.template() to set up where ProjectTemplate should look for your custom templates"),
                                  collapse = "\n"))
root <- "no_root"
        }
        else if (nrow(template.info)==0) {
                return(
                        message(paste0(c(paste0("No templates are located at ", .get.root.location()$location),
                                         "Add sub directories there to start using custom templates"),
                                       collapse = "\n"))
                )
        }
        else {
                templates <- ifelse(template.info$default, 
                                    paste0("(*) ", template.info$clean.names),
                                    paste0("    ", template.info$clean.names))
                message(paste0(c("The following templates are available:", 
                                 templates,
                                 "If no template specified in create.project(), the default (*) will be used"),
                               collapse = "\n"))
        }
        
}

.download.github <- function (location) {
        stop(".download.github not implemented")
}