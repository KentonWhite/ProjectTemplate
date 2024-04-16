#' Automatically load data and packages for a project.
#'
#' This function automatically load all of the data and packages used by
#' the project from which it is called.  The behavior can be controlled by
#' adjusting the \code{\link{project.config}} configuration.
#'
#' @param ... Named arguments to override configuration from \code{config/global.dcf}
#'   and \code{lib/global.R}.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @details \code{...} can take an argument override.config or a single named
#'   list for backward compatibility. This cannot be mixed with the new style
#'   override. When a named argument override.config is present it takes
#'   precedence over the other options. If any of the provided arguments is
#'   unnamed an error is raised.
#'
#' @export
#'
#' @import digest tibble
#'
#' @seealso \code{\link{create.project}}, \code{\link{get.project}},
#'   \code{\link{cache.project}}, \code{\link{show.project}}, \code{\link{project.config}}
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{load.project()}
load.project <- function(...)
{
  project_name <- .stopifnotproject("Please change to correct directory and re-run load.project()")

  my.project.info <- list()

  message('Project name: ', project_name)
  message('Loading project configuration')

  override.config <- .parse.override.config(list(...))
  config <- .load.config(override.config)
  config$.override.config <- override.config
  .check.version(config)

  assign('config', config, envir = .TargetEnv)
  my.project.info$config <- config

  options(stringsAsFactors = config$as_factors)

  if (config$load_libraries) {
    my.project.info <- .load.libraries(config, my.project.info)
  }

  if (config$logging) {
    my.project.info <- .init.logger(config, my.project.info)
  }

  my.project.info <- .load.helpers(config, my.project.info)

  if (config$data_loading | config$cache_loading) {
    my.project.info <- .load.data(config, my.project.info)
  }

  if (config$munging) {
    my.project.info <- .munge.data(config, my.project.info)
  }

  assign('project.info', my.project.info, envir = .TargetEnv)
}


#' Unload the project variables keeping the data
#'
#' Removes the \code{config}, \code{logger} and \code{project.info} variables
#' from memory, leaving all data variables in place.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @keywords internal deprecate
#'
#' @rdname internal.unload.project
.unload.project <- function() {
  suppressWarnings(rm(list = c("config", "logger", "project.info"),
                      envir = .TargetEnv))
}

## Load libraries listed in configuration into memory ------------------------

#' Load the libraries listed in the configuration into memory
#'
#' Load the libraries listed in the libraries entry in global.dcf and add the
#' library names to the \code{project.info}.
#'
#' @param config Named list containing the project configuration
#' @param my.project.info Named list containing the project information
#'
#' @return Returns \code{my.project.info} amended with the new information.
#'
#' @keywords internal
#'
#' @rdname internal.load.libraries
.load.libraries <- function(config, my.project.info) {
  message('Autoloading packages')
  my.project.info$packages <- c()

  for (package.to.load in strsplit(config$libraries, '\\s*,\\s*')[[1]]) {
    message(' Loading package: ', package.to.load)
    require.package(package.to.load)
    my.project.info$packages <- c(my.project.info$packages, package.to.load)
  }

  return(my.project.info)
}


## Initialize logging through log4r package ----------------------------------

#' Initialize the logger for the project
#'
#' Creates a \code{log4r::logger} and provides a default log file
#' \code{log/project.log}.
#'
#' @inherit .load.libraries params return
#'
#' @keywords internal
#'
#' @rdname internal.init.logger
.init.logger <- function(config, my.project.info) {
  message('Initializing logger')
  require.package('log4r')

  logger <- log4r::create.logger()
  .provide.directory('logs')

  if("logs_sub_dir" %in% names(config$.override.config)){
    log4r::logfile(logger) <- file.path('logs',config$.override.config$logs_sub_dir, 'project.log')
  } else {
    log4r::logfile(logger) <- file.path('logs', 'project.log')
  }
  log4r::level(logger) <- config$logging_level
  assign('logger', logger, envir = .TargetEnv)
  return(my.project.info)
}


## Load helper functions -----------------------------------------------------

#' Load the helper functions
#'
#' Sources all helper scripts in \code{lib}. If \code{lib/globals.R} exists this
#' is loaded first, all other scripts are sourced in alphabetical order.
#'
#' @inherit .load.libraries params return
#'
#' @keywords internal
#'
#' @rdname internal.load.helpers
.load.helpers <- function(config, my.project.info) {
  if (file.exists('lib')) {
    message('Autoloading helper functions')

    my.project.info$helpers <- c()

    helpers <- dir('lib', pattern = '[.][rR]$')

    # force globals.R to be read first, if it exists
    if ("globals.R" %in% helpers) {
      helpers <- c("globals.R", helpers[!(helpers %in% "globals.R")])
    }

    deprecated.files <- intersect(
      helpers, c('boot.R', 'load_data.R', 'load_libraries.R',
                 'preprocess_data.R', 'run_tests.R'))
    if (length(deprecated.files) > 0) {
      warning(paste('Skipping deprecated files:',
                    paste(deprecated.files, collapse = ', ')))
    }

    for (helper.script in helpers) {
      message(' Running helper script: ', helper.script)
      source(file.path('lib', helper.script), local = .TargetEnv)
      my.project.info$helpers <- c(my.project.info$helpers, helper.script)
    }
  }
  return(my.project.info)
}


## Load data into memory from cache/ and data/ -------------------------------

#' Load the data from the cache and data directories
#'
#' Gets the list of available variables in \code{cache/} and \code{data/} and
#' loads the data in memory. Data from the cache is loaded first, then in
#' alphabetical order.
#'
#' @inherit .load.libraries params return
#'
#' @keywords internal
#'
#' @rdname internal.load.data
.load.data <- function(config, my.project.info) {
  message('Autoloading data')

  data.files.loaded <- c()
  cache.files.loaded <- c()

  # List all available data
  data.files <- .list.data(config)
  # Order the data such that cached only variables are loaded first, and then
  # everything in alphabetical order
  load.order <- order(data.files$cache_only,
                      data.files$filename,
                      data.files$varname,
                      decreasing = c(TRUE, FALSE, FALSE),
                      method = "radix")

  # Loop over all rows in the list in the determined order
  for (f in load.order) {
    data.file <- data.files[f,]
    variable <- data.file$varname

    # Check if file must be loaded
    is_loaded <- variable %in% ls(envir = .TargetEnv)
    if (is_loaded | data.file$is_ignored) {
      next()
    }

    if (config$cache_loading & data.file$is_cached) {
      cache_format <- .cache.format()

      # Load data from cache/
      message(" Loading cached data set: ", variable)
      cache_filename <- .cache.filename(variable, cache_format)
      eval(cache_format[["load_expr"]])
      cache.files.loaded <- c(cache.files.loaded, variable)
    } else if (config$data_loading) {
      # Check if a reader was found for the file
      has_reader <- ((class(data.file$reader[[1]]) == "function") || !(data.file$reader[[1]] == ''))
      if (!has_reader) {
        next()
      }
      # Load data from data/
      message(" Loading data set: ", variable)
      reader.args <- list(data.file$filename,
                          file.path('data', data.file$filename),
                          variable)

      # Register current variables
      vars.old <- .var.diff.from()
      # Actually load the data
      do.call(data.file$reader[[1]], reader.args)
      # Get new variables introduced by the reader
      vars.new <- .var.diff.from(vars.old)

      if (config$tables_type == 'data_table') {
        .convert.to.data.table(vars.new)
      }

      if (config$tables_type == 'tibble') {
        .convert.to.tibble(vars.new)
      }

      if (config$cache_loaded_data && length(vars.new) > 0) {
        sapply(vars.new, cache)
      }

      data.files.loaded <- c(data.files.loaded, vars.new)
    }
  }

  my.project.info$cache <- cache.files.loaded
  my.project.info$data <- data.files.loaded
  return(my.project.info)
}


#' Convert one or more data sets to data.tables
#'
#' Converts all \code{base::data.frame}s referred to in the input to
#' \code{data.table}s. The resulting data set is stored in the
#' \code{.TargetEnv}.
#'
#' @param data.sets A character vector of variable names.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @keywords internal
#'
#' @rdname internal.convert.to.data.table
.convert.to.data.table <- function(data.sets) {
  .require.package("data.table")

  for (data.set in data.sets) {
    # Get current version of the dataset
    loaded.data <- get(data.set, envir = .TargetEnv, inherits = FALSE)
    if (all(class(loaded.data) == 'data.frame')) {
      message(' Translating data.frame to data.table: ', data.set)
      assign(data.set, data.table::data.table(loaded.data), envir = .TargetEnv)
    }
  }
}


#' Convert one or more data sets to tibbles
#'
#' Converts all \code{base::data.frame}s referred to in the input to
#' \code{tibble}s. The resulting data set is stored in the
#' \code{.TargetEnv}.
#'
#' @param data.sets A character vector of variable names.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @keywords internal
#'
#' @rdname internal.convert.to.tibble
.convert.to.tibble <- function(data.sets) {
  require.package("tibble", FALSE)

  for (data.set in data.sets) {
    # Get current version of the dataset
    loaded.data <- get(data.set, envir = .TargetEnv, inherits = FALSE)
    if (all(class(loaded.data) == 'data.frame')) {
      message(' Translating data.frame to tibble: ', data.set)
      assign(data.set, tibble::as_tibble(loaded.data), envir = .TargetEnv)
    }
  }
}


## Run all scripts in the munge/ directory -----------------------------------

#' Source all munge scripts
#'
#' Sources all munge scripts in the \code{munge} directory in alphabetical
#' order.
#'
#' @inherit .load.libraries params return
#'
#' @keywords internal
#'
#' @rdname internal.munge.data
.munge.data <- function(config, my.project.info) {
  message('Munging data')
  if("munge_sub_dir" %in% names(config$.override.config)){
    dir_name <- file.path("munge",config$.override.config[["munge_sub_dir"]])
  } else {
    dir_name <-'munge'
  }

  munge_files <- function(dir_name){
    if("munge_files" %in% names(config$.override.config)){
      munge.files <- paste0(config$.override.config[["munge_files"]], collapse="|")
    } else{
      munge.files <- '[.][rR]|[.][pP][yY]$' # Add .py files
    }
    return(munge.files)
  }
  for (preprocessing.script in sort(dir(dir_name, pattern = munge_files())))
  {
    message(' Running preprocessing script: ', preprocessing.script)
    # Check for Python extension using tolower() for case-insensitivity
    if (tolower(tools::file_ext(preprocessing.script)) == "py") {
      message(' Sourcing Python script: ', preprocessing.script)
      reticulate::source_python(file.path(dir_name, preprocessing.script))
    } else {
      message(' Sourcing R script: ', preprocessing.script)
      source(file.path(dir_name, preprocessing.script), local = .TargetEnv)
    }
  }
  return(my.project.info)
}

# Auxiliary functions for loading/unloading projects -------------------------

#' Make sure a required directory exists before usage
#'
#' Checks if the requested directory exists, and if not creates the directory.
#' In the latter case a warning is raised.
#'
#' @param name Character vector containing the name of the required directory.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @keywords internal
#'
#' @rdname internal.provide.directory
.provide.directory <- function(name) {
  is.dir <- file.info(name)$isdir
  if (is.na(is.dir) || !is.dir) {
    warning("Creating missing directory ", name)
    dir.create(name)
  }
  if("logs_sub_dir" %in% names(config$.override.config)){
    is.dir <- file.info(file.path(name,config$.override.config$logs_sub_dir))$isdir
    if (is.na(is.dir) || !is.dir) {
      warning("Creating missing directory ", config$.override.config$logs_sub_dir)
      dir.create(file.path(name,config$.override.config$logs_sub_dir))
    }
  }

}


#' Compare the project version with the current ProjectTemplate version
#'
#' @param config Project configuration
#' @param warn.migrate Logical indicating whether a warning should be raised if
#'   the project version is older than the installed version of ProjectTemplate.
#'
#' @inherit utils::compareVersion return
#'
#' @keywords internal
#'
#' @rdname internal.check.version
#'
#' @importFrom utils compareVersion
.check.version <- function(config, warn.migrate = TRUE) {
  package.version <- .package.version()
  version.diff <- compareVersion(config$version, package.version)
  if (version.diff < 0) {
    if (warn.migrate) {
      warning('Your configuration is compatible with version ', config$version,
              ' of the ProjectTemplate package.\n  Please run ProjectTemplate::migrate.project() to migrate to the installed version ',
              package.version, '.')
    }
  } else if (version.diff > 0) {
    stop('Your configuration is compatible with version ', config$version,
         ' of the ProjectTemplate package.\n  Please upgrade ProjectTemplate to version ', config$version, ' or later.')
  }

  version.diff
}


#' Get the current ProjectTemplate version
#'
#' Reads the installed version of ProjectTemplate from the \code{DESCRIPTION}
#' file.
#'
#' @return Version as a character vector.
#'
#' @keywords internal
#'
#' @rdname internal.package.version
.package.version <- function() {
  as.character(read.dcf(system.file("DESCRIPTION", package = "ProjectTemplate"), fields = "Version"))
}


#' Compare sets of variable names
#'
#' Compare the variables (excluding functions) in the global env with a passed
#' in string of names and return the set difference.
#'
#' @param given.var.list Character vector of variable names
#' @param env Environment in which to compare the sets of variables
#'
#' @keywords internal
#'
#' @rdname internal.var.diff.from
.var.diff.from <- function(given.var.list="", env=.TargetEnv) {
  # Get variables in target environment of determine if they are a function
  current.var.list <- sapply(ls(envir = env), function(x) is.function(get(x)))
  current.var.list <- names(current.var.list[current.var.list == FALSE])

  # return those not in list
  setdiff(current.var.list, given.var.list)
}
