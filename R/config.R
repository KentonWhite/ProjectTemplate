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
#      .convert.config.types   - convert character values from DCF to preconfigured data types
#      .boolean.cfg            - convert "TRUE"/"on" and "FALSE"/"off" to R values
#      .parse.override.config  - if load.project is called with the oldstyle override.config argument
#                                or a single list is passed the items from this list are used.
#      .apply.override.config  - Apply settings from override.config to the loaded configuration
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
# 3.  Add the new item to the config types file (location shown below) with the data type of the option. Defaults
#     to character, also supported are boolean and numeric. New type conversions can be implemented in the
#     .convert.config.types function.
# 4.  Add some logic to migrate.project() if necessary to tell the user about the new configuration item that
#     is now available, perhaps asking them to double check the defaults after migration
# 5.  Add some tests to make sure your new config works correctly pre and post migration
# 6.  Update the website documentation website/configuring.markdown with the new functionality
# 7.  Update the man page under project.config.R with the new functionality
#


# Config file locations

## ProjectTemplate standard file location of the config file
.project.config <- file.path('config', 'global.dcf')

## File that specifies default config values to be used in load.project() if config items are missing
## from a particular ProjectTemplate directory (because e.g. it was created under a previous version of PT and
## migrate.project() hasnt been run yet)
.default.config.file <- system.file('defaults/config/default.dcf', package = 'ProjectTemplate')

## File that contains the default initial project configuration after create.project()
.new.config.file <- system.file('defaults/templates/full/config/global.dcf', package = 'ProjectTemplate')

## File that contains the datatypes for the options in global.dcf
.config.types.file <- system.file('defaults/config/types.dcf', package = 'ProjectTemplate')

# read the default and new configurations
.default.config <- translate.dcf(.default.config.file)
.new.config <- translate.dcf(.new.config.file)
.config.types <- translate.dcf(.config.types.file)

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

  config <- .apply.override.config(config, override.config)

  extra.entries <- setdiff(names(config), names(.default.config))
  if (length(extra.entries) > 0) {
    warning('Your configuration contains the following unused entries: ',
            paste(extra.entries, collapse = ', '), '. These will be ignored.')
    config[extra.entries] <- NULL
  }

  .convert.config.types(config)
}


# save config and update package version
.save.config <- function (config) {
  config$version <- .package.version()
  write.dcf(config, .project.config)
}

# read in a config file and return an unvalidated config object
.read.config <- function (file=.project.config) {
  config <- translate.dcf(file)
  config <- .convert.config.types(config)
  config
}


.convert.config.types <- function(config) {
  .convert <- function(setting, value) {
    type <- .config.types[[setting]]
    if (type == 'boolean') {
      value <- .boolean.cfg(value)
    } else if (type == 'numeric') {
      value <- as.numeric(value)
    }
    value
  }
  mapply(.convert, names(config), config, SIMPLIFY = FALSE)
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
  if (format=="text") {
    # length of the longest config item name plus 3 spaces for padding
    max_size <- max(nchar(names(config))) + 3
    fmt <- sprintf("%%-%ds", max_size)
    # return a text string
    return(paste0(sprintf(fmt, names(config)), config, collapse = "\n"))
  } else {
    # return an Rd encoded string
    var <- paste0("\\code{",names(config), "} \\tab \\code{", config, "} \\cr ", collapse = "")
    return(paste0("\\tabular{ll}{", var, "}"))
  }
}

# Helper function to parse extra arguments to .load.config
.parse.override.config <- function(args) {
  if (is.null(args) || length(args) == 0) {
    return(NULL)
  }
  if ('override.config' %in% names(args)) {
    args <- args[['override.config']]
  } else if (length(args) == 1 && class(args[[1]]) == 'list' && is.null(names(args))) {
    args <- args[[1]]
  } else if (is.null(names(args)) || any(names(args) == "")) {
    stop('All options should be named')
  }
  args
}

# Helper function to apply overridden configuration
.apply.override.config <- function(config, override.config) {
  if (length(override.config) > 0) {
    override.names <- intersect(names(config), names(override.config))
    config[override.names] <- override.config[override.names]
  }
  config
}
