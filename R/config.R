#
# This file contains internal functions to handle the project configuration in config/global.dcf
# These functions are used internally by several user facing functions.
#
# Key functions are:
#      .read.config    -  read a raw config file in DCF format and create a config object (no validation performed)
#      .load.config    -  read and validate a config file
#      .save.config    -  save a config object back into a DCF format config file
#
# Supporting functions are:
#      .normalize.boolean  - convert boolean values in the config file into TRUE/FALSE objects
#      .normalize.config   - convert strings read from DCF format into R object values
#      .boolean.cfg        - convert "TRUE"/"on" and "FALSE"/"off" to R values
#

# Make sure translate.dcf is loaded before this file is built
#' @include translate.dcf.R


#
# Note to developers who wish to add new config items into ProjectTemplate
#
# 1.  Add the new item to the default config file (location shown below) with the default value that you
#     want all new projects to have after a create.project() is called.
# 2.  Add the new item to the new config file (location shown below) with the default value that you want
#     to be used when existing projects are called using load.project() but they don't have your new item yet
#     because migrate.project() hasn't been run.  For example, if something is on by default in new projects,
#     you may choose to have it switched off for existing projects to not break them before they are migrated
# 3.  Add some logic to migrate.project() if necessary to tell the user about the new configuration item that
#     is now available, perhaps asking them to double check the defaults after migration
# 4.  Add some tests to make sure your new config works correctly pre and post migration
# 5.  Update the website documentation website/configuring.markdown with the new functionality
# 6.  Update the man page under project.config.R with the new functionality
# 7.  If your new config item is not a simple TRUE/FALSE flag, add its name to the .nonflag.config variable
#     below so that it is processed correctly by the config validation functions
#


# Config file locations

## ProjectTemplate standard file location of the config file
.project.config <- file.path('config', 'global.dcf')

## File that specifies default config values to be used in load.project() if config items are missing
## from a particular ProjectTemplate directory (because e.g. it was created under a previous version of PT and
## migrate.project() hasnt been run yet)
.default.config.file <- system.file('defaults/config/default.dcf', package = 'ProjectTemplate')

## File that contains the default initial project configuration after create.project()
.new.config.file <- system.file('defaults/full/config/global.dcf', package = 'ProjectTemplate')

# items in the configuration file which are not TRUE/FALSE (or on/off) values
.nonflag.config <- c("version", "libraries", "logging_level", "sticky_variables", "data_ignore")

# read the default and new configurations
.default.config <- translate.dcf(.default.config.file)
.new.config <- translate.dcf(.new.config.file)

# load and validate the config and return a config object

.load.config <- function(override.config = NULL) {
        config <- if (file.exists(.project.config)) {
                 translate.dcf(.project.config)
        } else {
                warning('You are missing a configuration file: ', .project.config, ' . Defaults will be used.')
                .default.config
        }

        missing.entries <- setdiff(names(.default.config), names(config))
        if (length(missing.entries) > 0) {
                warning('Your configuration file is missing the following entries: ',
                        paste(missing.entries, collapse = ', '), '. Defaults will be used.')
                config[missing.entries] <- .default.config[missing.entries]
        }

        if (length(override.config) > 0) {
                config[names(override.config)] <- override.config
        }

        extra.entries <- setdiff(names(config), names(.default.config))
        extra.entries <- grep("^[^#]", extra.entries, value = TRUE)
        if (length(extra.entries) > 0) {
                warning('Your configuration contains the following unused entries: ',
                        paste(extra.entries, collapse = ', '), '. These will be ignored.')
                config[extra.entries] <- NULL
        }

        config <- .normalize.boolean(config)

        config
}


# save config and update package version
.save.config <- function (config) {
        config$version <- .package.version()
        write.dcf(config, .project.config)
}

# read in a config file and return an unvalidated config object
.read.config <- function (file=.project.config) {
        config <- translate.dcf(file)
        config <- .normalize.boolean(config, default=config)
        config
}


# normalize all config boolean items (ie set as on/off or TRUE/FALSE character strings) into R objects TRUE or FALSE
.normalize.boolean <- function (config, default=.default.config) {
        .normalize.config(config,
                  setdiff(names(default), .nonflag.config),
                  .boolean.cfg)
}



# Normalization helper functions:
#   .normalize.config is a generic function to apply any normalization function to specific config items


# Apply a normalization function to specified config item to convert from raw character string to an R object value
.normalize.config <- function(config, names, norm.fun) {
        config[names] <- lapply(config[names], norm.fun)
        config
}

# normalization function to convert character flags into TRUE/FALSE
.boolean.cfg <- function(x) {
        ret <- if (x == 'on') TRUE
        else if (x == 'off') FALSE
        else as.logical(x)
        if (is.na(ret)) stop('Cannot convert ', x, ' to logical value.')
        ret
}

# function to display the content of a config file neatly
# supports text for display on a console and Rd for parsing inside a man page
.format.config <- function (config, format = "text") {
        ifelse(format=="text", {
                        # length of the longest config item name plus 3 spaces for padding
                        max_size <- max(nchar(names(config))) + 3
                        fmt <- sprintf("%%-%ds", max_size)
                        # return a text string
                        paste0(sprintf(fmt, names(config)), config, collapse = "\n")
                        },
                        {
                        # return an Rd encoded string
                        var <- paste0("\\code{",names(config), "} \\tab \\code{", config, "} \\cr ", collapse = "")
                        paste0("\\tabular{ll}{", var, "}")
                        }
        )
}

