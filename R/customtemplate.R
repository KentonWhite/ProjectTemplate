# This file has the main infrastructure for the custom template subsystem.  There 
# are no functions exported to users from here - instead the user facing functions make
# calls here

# Custom templates can be configured for each different installation of ProjectTemplate
# There can be multiple templates, and one of them is a default.  They are invoked by
#     create.project("project-name", "template-name")
# or
#     create.project("project-name") to invoke the default template
#
# First of all, the standard ProjectTemplate structure is created.  Then the structure
# defined for each template name is copied into the standard structure, overwriting 
# anything already there, and adding any new files.
#
# The available templates for a site are defined in a file called the root template
# file which is stored in the etc directory of the current R installation directory.  
#
# The etc location is chosed in order to preserve config
# between updates to ProjectTemplate itself, but import and export functions are provided 
# to allow config to be preserved between different versions of R.
#
# A user function templates() provides a management interface to manage the
# installed templates on a system.
#
# Template designers can simply create directory structures for any functionality they 
# want to, e.g. knitr templates, shinyapps, corporate analysis standards etc.
#
# There is an advanced template design feature, whereby the template is described in
# a template definition file.  This allows for re-use of functionalility between templates
# (e.g. a lib function that you'd like to make available in many templates).  It also
# allows more fine grained control than just plain copy-and-overwrite.  For example, it
# can be specifed for a .gitignore segment on a template to be appended to an existing
# .gitignore in the target project template directory.
# NB:  Advanced template design has not been implemented yet.  It will be added over time
#
# Template definitions are stored in a DCF format file, and loaded into a dataframe for 
# processing.  There can be multiple DCF records defined in a single file.  Each record
# can the following fields (depending on template_type):
#
#
#      template_type:           type of template definition:
#                                       root - template root file for a site installation
#                                       project - individual template definition 
#
#      content_location:        where template content can be found:
#                                       local::/path/to/content/dir.or.file
#                                       github:username/repo@branch:path/to/content.or.file
#
#
#      merge:                   determines how file content is handled when it clashes with
#                               files of the same name in the target project:
#                                       overwrite/append/duplicate 
#
#      template_name:           Name of template that the content relates to
#
#      target_dir:              directory relative to project where content is placed 
#
#       default:                whether this record is the default template
#


# Root template definition file uses this format with some restrictions:  
#  if the field no_templates_defined: is present, the template definition is not defined
#       merge:     not used
# target_dir:      not used
#
# The file is stored in the ProjectTemplate package under the directory:
#           {R Home}/etc 
# and is named ProjectTemplateRootConfig.dcf.  
#
# General template definition files reside directly under the template subdirectory
# with the name template-definition.dcf.  If this file exists, it is used to build the
# template structure.  If not, any files or folders are copied directly (with over-write)
# to the target project directory.  


#
# Custom template functions start here .....
#

# First, Some short cut definitions to aid readability

# Where is the root template location defined - put in the R/etc folder to preserve config
# between installs of ProjectTemplate
.root.template.dir <- file.path(R.home(), "etc")
.root.template.file <- file.path(.root.template.dir, "ProjectTemplateRootConfig.dcf")

# Types of template configuration allowed
.available.template.types <- c("root", "project")
.template.field.names <- c("template_type", "content_location", "template_name")
.root.template.field.names <- c( "default")
.project.template.field.names <- c("merge", "target_dir")
.template.merge.types <- c("overwrite", "append", "duplicate")
.no.templates <- "no_templates_defined"

# Helper function to remove the first item in a list
.remove.first <- function (x) rev(head(rev(x), -1))


# Internal functions called by user facing functions templates() and create.project()

# apply the selected template to the specified directory
.apply.template <- function(template_name, target_location) {
        
        template <- .get.template(template_name)
        
        if (is.null(template)) {
                message(paste0("Template ", template_name, " is not installed"))
                .quietstop()
        }
        
        # go get template from github if necessary
        if (template$location_type=="github") {
                
                download_dir <- suppressMessages(.download.github.template(template$github_repo))
                file_location <- file.path(download_dir, template$file_location)
                on.exit(unlink(file.path(download_dir, "..", "..", recursive=TRUE)))
                
        } else if (template$location_type=="local") {
                file_location <- as.character(template$file_location)
        }
        
        # if the file_location is a directory, process it directly, otherwise process
        # it as a custom project template definition file
        if (dir.exists(file_location)) {
                .add.from.directory.template(file_location, target_location)
                message(paste0("Applied template: ", template$template_name, "\n"))
        }
        else if (file.exists(file_location)) {
                stop("Project definition files not implemented yet")
                #.add.from.dcf.template(file_location, target_location)
        }
        else {
                stop(paste0("Invalid Template location: ", file_location, "\n"))
        }
        
        # Change to the target location directory
        # Re-read and save the config to make sure it has the latest version number
        setwd(target_location)
        .save.config(suppressWarnings(.load.config(compare.config=.new.config)))
        
        
}

# Blindly copy template file structure from a local location into the target
.add.from.directory.template <- function(template_location, target_location) {
        template_files <- file.path(template_location,.list.files.and.dirs(template_location))
        file.copy(template_files, target_location, 
                  overwrite = TRUE, recursive = TRUE, 
                  copy.mode = TRUE)
        
}


# get the relevant template by number, name or default (if there is one)
.get.template <- function (template.name=NULL, default=FALSE) {
        
        # get the template definition
        definition <- .read.root.template()
        
        if(!.templates.defined(definition))  
                return (NULL)
        
        if (default) {
                # return the name of the default template (if there is one)
                template <- definition[definition$default==TRUE,]
                if(nrow(template)==1)
                        return(template$template_name)
                return(NULL)
        }
        
        if (is.null(template.name)) {
                message("Template name or number must be provided")
                .quietstop()
        }
        
        
        if (is.character(template.name))
                template <- definition[definition$template_name==template.name,]
        if (is.numeric(template.name))
                template <- definition[template.name,]
        
        # return the template record, if there is one
        if (nrow(template)==1 && !is.na(template$template_type))
                return (template)
        
        stop(paste0("No such template: ", template.name, "\n"))
        
}

# add a location to the existing root template file

.add.template.location <- function (template.name, location) {
        
        new_template <- data.frame(template_type="root",
                                   content_location=location,
                                   template_name=template.name,
                                   default=FALSE,
                                   stringsAsFactors = FALSE)
        # Check it and produce extended database record
        new_template <- .validate.root.template(.validate.template.definition(new_template))
        current_templates <- .read.root.template()
        
        if (.templates.defined(current_templates))
                new_template <- .validate.root.template(rbind(current_templates, new_template))
        .save.root.template(new_template)
}

# remove a template from the existing  root template file

.remove.template.location <- function (template.name) {
        
        remove_template <- .get.template(template.name)
        current_templates <- .read.root.template()
        
        if (is.null(remove_template) || is.null(current_templates))
                stop(paste0("Unable to remove template: ", template.name))
        
        new_template <- current_templates[!(current_templates$template_name %in% 
                                                    remove_template$template_name),]
        .save.root.template(new_template)
}

# set which template is the default 
.set.default.template <- function (template.name) {
        
        # get the relevant row from the definition file
        template <- .get.template(template.name)
        template$default <- TRUE
        
        if(is.null(template)) return(invisible(NULL))
        
        # make sure there is no default
        .no.default.template()
        
        # get the template definition
        definition <- .read.root.template()
        
        # replace the entry for template.name with one with the default set
        definition[definition$template_name==template$template_name,] <- template
        
        .save.root.template(definition)
}

# remove default template 
.no.default.template <- function () {
        
        
        # get the template definition
        definition <- .read.root.template()
        
        if(!.templates.defined(definition))  
                return(NULL)
        
        
        # reset the default column
        definition$default <- rep(FALSE, nrow(definition))
        
        # save it
        .save.root.template(definition)
        
}



# Internal functions to manipulate the root template file

# Read a template definition file, validate it and return the contents as a dataframe
# If no file parameter specified, the function reads the .root.template.file, otherwise
# another dcf file can be specified which is validated and then saved in place of the
# current .root.template.file
# Note that the definition object is passed to validate and save routines
.read.root.template <- function (template.file=.root.template.file) {
        
        .require.root.template()
        
        # read the file from disk and perform basic validation
        definition <- .read.template.definition(template.file)
        
        # if no root template defined return NULL
        if(!.templates.defined(definition))  
                return (NULL)
        
        # validate the root template
        definition <- .validate.root.template(definition)
        
        # Save any validation fixes back
        .save.root.template(definition)
        
        definition
}

# Check the root template definition has the right format
.validate.root.template <- function(definition) {
        
        # return if no templates
        if(!.templates.defined(definition))  
                return (NULL)
        
        # Make sure only root items are included in the definition
        definition <- definition[definition$template_type == "root",]
        
        # Mandatory fields for root templates should be present
        missing_names <- setdiff(.root.template.field.names, names(definition))
        if (length(missing_names) != 0) {
                stop(paste0("Missing template field: ", missing_names, "\n"))
        }
        
        # make the default column a logical value
        definition$default <- as.logical(definition$default)
        
        # Make sure there are no duplicate template_name
        duplicates <- definition$template_name[duplicated(definition$template_name)]
        if (length(duplicates) > 0) {
                stop(paste0("Duplicate template name found in template_name field: ", duplicates, "\n"))
        }
        
        # Create a user friendly display name for the templates, numbering each one
        # and marking the default with a (*)
        definition$display_name <- paste0(row.names(definition), ".",
                                          ifelse(definition$default, "(*) ", "    "),
                                          definition$template_name)
        
        definition
}


# Save a validated template definition file as the root template
.save.root.template <- function (definition) {
        
        definition <- .validate.root.template(definition)
        root_template_fields <- c(.template.field.names, .root.template.field.names)
        
        # only save relevant columns from the definition
        definition <- definition[,root_template_fields]
        write.dcf(definition, .root.template.file, keep.white = "content_location")
}

# Backup root template file into specified directory
.backup.root.template <- function (directory = getwd()) {
        .require.root.template()
        backup.location <- file.path(directory, basename(.root.template.file))
        file.copy(.root.template.file, backup.location, overwrite = TRUE)
        return(backup.location)
}

# Restore root template file 
.restore.root.template <- function (backup.file = basename(.root.template.file)) {
        if (!file.exists(backup.file))
                stop("Backup file not found")
        definition <- .read.root.template(backup.file)
        .save.root.template(definition)
        invisible(NULL)
}

# Clear all root template definitions
.clear.root.template <- function () {
        .require.root.template()
        unlink(.root.template.file)
        .require.root.template()
        invisible(NULL)
}

# Check if the root template file exists, if it doesn't create an empty one
.require.root.template <- function() {
        if(!file.exists(.root.template.file)) {
                no_templates <- data.frame(x="")
                colnames(no_templates) <- .no.templates
                write.dcf(no_templates, .root.template.file)
        }
}

# Provide the status of templates defined in the root template
.root.template.status <- function (full=FALSE) {
        template.definition <- .read.root.template()
        if (!.templates.defined(template.definition)) {
                message(paste0(c("Custom Templates not configured for this installation."),
                                  collapse = "\n"))
        }
        
        else {
                message("The following templates are available:")
                if (!full) {
                        message(paste0(template.definition$display_name,
                                       collapse = "\n"))
                }
                else {
                        # Provide detailed configuration
                        m <- c()
                        e <- environment()
                        apply(template.definition, 1, function (t) {
                              m <- c(m, t['display_name'])
                              m <- c(m, paste0("        type: ", t['location_type']))
                              if (t['location_type']=="github") 
                                      m <- c(m, paste0("        github repo: ", t['github_repo']))
                              m <- c(m, paste0("        directory: ", t['file_location']))
                              m <- c(m, "")
                              assign("m", m, envir = e)
                              }
                        )
                        message(paste0(m, collapse = "\n"))
                }
                               
        }
        
}


# Internal functions to read and validate root template files from disk


# Read a template definition file, validate it and return the contents as a dataframe
.read.template.definition <- function (template.file) {
        definition <- as.data.frame(read.dcf(template.file), 
                                    stringsAsFactors = FALSE)
        
        # return NULL if no templates defined
        if (!.templates.defined(definition)) 
                return(NULL)
        
        definition <- .validate.template.definition(definition)
        
        definition
}

# Determine whether custom templates are present
.templates.defined <- function(definition){
        if ((.no.templates %in% names(definition)) || is.null(definition) ||
            nrow(definition)==0)
                return(FALSE)
        return(TRUE)
}



# enforce some rules about all template types:
#       check field names are correct
#       template_type of right format
#       merge types of the right format
#       content_location in the correct format
# stop if any validation breaks
.validate.template.definition <- function(definition) {
        
        
        # Mandatory fields should be present
        missing_names <- setdiff(.template.field.names, names(definition))
        if (length(missing_names) != 0) {
                stop(paste0("Missing template field: ", missing_names, "\n"))
        }
        
        # Check that the template type field is valid
        invalid_types <- setdiff(definition$template_type, .available.template.types)
        if(length(invalid_types)>0) {
                stop(paste0("Invalid template type: ", invalid_types, "\n"))
        }
        
        # Make sure merge types are valid
        invalid_mergetypes <- setdiff(definition$merge,.template.merge.types)
        if (length(invalid_mergetypes) != 0) {
                stop(paste0("Invalid values found in merge field: ", invalid_mergetypes))
        }
        
        # Parse the content_location field to extract the embedded information
        definition <- .parse.content.location(definition)
        
        definition
}

# take a template definition dataframe, parse the content_location field into
# the valid components and return the definition frame with the new columns
.parse.content.location <- function(definition) {
        
        # Parse the content_location field to extract the embedded information
        content_location <- strsplit(definition$content_location, ":")
        
        location_type <- sapply(content_location, function (x) x[1])
        file_location <- sapply(content_location, function (x) x[3])
        github_repo <- sapply(content_location, function (x) x[2])
        
        # Validate the location_type
        valid_locations <- c("local", "github")        
        invalid_types <- setdiff(location_type, valid_locations)
        if(length(invalid_types)>0) {
                stop(paste0("Invalid location types: ", invalid_types))
        }
        definition <- cbind(definition, data.frame(location_type=location_type,
                                                   file_location=file_location,
                                                   github_repo=github_repo) )
        definition
}







.download.github.template <- function (location) {
        
        # location is in format github_user/repo_name@branch
        
        gh_remote <- devtools:::github_remote(location)
        file_location <- devtools:::remote_download.github_remote(gh_remote)
        
        # get a temporary directory to unzip the downloaded file
        file_directory <- tempfile("github")
        dir.create(file_directory)
        
        oldwd <- setwd(file_directory)
        on.exit(setwd(oldwd), add = TRUE)
        
        unzip(file_location)
        unlink(file_location)
        
        # get zipped directory name which is the sole item now in the directory
        dir <- .list.files.and.dirs(file_directory)
        
        # return local location of the downloaded template
        file.path(file_directory, dir)
}


