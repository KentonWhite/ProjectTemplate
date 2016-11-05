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
#      .normalize.config   - convert strings read from DCF format into R object values
#      .boolean.cfg        - convert "TRUE"/"on" and "FALSE"/"off" to R values
#

# Config file locations

## ProjectTemplate file location of the config file
.config.path <- file.path('config', 'global.dcf')

## File that specifies default config values to be used in load.project() if config items are missing
## from a particular ProjectTemplate directory (because e.g. it was created under a previous version of PT and
## migrate.project() hasnt been run yet)
.default.config.file <- system.file('defaults/config/default.dcf', package = 'ProjectTemplate')

## File that contains the default initial project configuration after create.project()
.new.config.file <- system.file('defaults/full/config/global.dcf', package = 'ProjectTemplate')


# read the raw files

.default.config <- translate.dcf(.default.config.file)
.new.config <- translate.dcf(.new.config.file)


.load.config <- function(override.config = NULL) {
        config <- if (file.exists(.config.path)) {
                translate.dcf(.config.path)
        } else {
                warning('You are missing a configuration file: ', .config.path, ' . Defaults will be used.')
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
        
        config <- .normalize.config(config,
                                    setdiff(names(.default.config), c("version", "libraries", "logging_level")),
                                    .boolean.cfg)
        
        
        config
}


# save config and update package version
.save.config <- function (config) {
        config$version <- .package.version()
        write.dcf(config, .config.path)
}

# read in a config file and return a config object
.read.config <- function (file=.config.path) {
        config <- translate.dcf(file)
        config <- .normalize.config(config,
                                    setdiff(names(.default.config), c("version", "libraries", "logging_level")),
                                    .boolean.cfg)
        config
}




.normalize.config <- function(config, names, norm.fun) {
        config[names] <- lapply(config[names], norm.fun)
        config
}

.boolean.cfg <- function(x) {
        ret <- if (x == 'on') TRUE
        else if (x == 'off') FALSE
        else as.logical(x)
        if (is.na(ret)) stop('Cannot convert ', x, ' to logical value.')
        ret
}
