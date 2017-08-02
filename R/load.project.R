#' Automatically load data and packages for a project.
#'
#' This function automatically load all of the data and packages used by
#' the project from which it is called.  The behaviour can be controlled by
#' adjusting the \code{\link{project.config}} configuration.
#'
#' @param override.config Named list, allows overriding individual configuration
#'   items.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @seealso \code{\link{create.project}}, \code{\link{get.project}},
#'   \code{\link{cache.project}}, \code{\link{show.project}}, \code{\link{project.config}}
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{load.project()}
load.project <- function(override.config = NULL)
{
  project_name <- .stopifnotproject("Please change to correct directory and re-run load.project()")

  my.project.info <- list()

  message('Project name: ', project_name)
  message('Loading project configuration')

  config <- .load.config(override.config)
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

.unload.project <- function() {
  suppressWarnings(rm(list = c("config", "logger", "project.info"),
                      envir = .TargetEnv))
}

## Load libraries listed in configuration into memory ------------------------
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
.init.logger <- function(config, my.project.info) {
  message('Initializing logger')
  require.package('log4r')

  logger <- log4r::create.logger()
  .provide.directory('logs')

  log4r::logfile(logger) <- file.path('logs', 'project.log')
  log4r::level(logger) <- config$logging_level
  assign('logger', logger, envir = .TargetEnv)
  return(my.project.info)
}

## Load helper functions -----------------------------------------------------
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
      # Load data from cache/
      message(" Loading cached data set: ", variable)
      cache.file <- file.path(.cache.dir, paste0(variable, .cache.file.ext))
      load(cache.file, envir = .TargetEnv)
      cache.files.loaded <- c(cache.files.loaded, variable)
    } else if (config$data_loading) {
      # Check if a reader was found for the file
      has_reader <- data.file$reader != ''
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
      do.call(data.file$reader, reader.args)
      # Get new variables introduced by the reader
      vars.new <- .var.diff.from(vars.old)

      if (config$data_tables) {
        .convert.to.data.table(vars.new)
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

## Convert datasets to data.table
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

## Run all scripts in the munge/ directory -----------------------------------
.munge.data <- function(config, my.project.info) {
  message('Munging data')
  for (preprocessing.script in sort(dir('munge', pattern = '[.][rR]$')))
  {
    message(' Running preprocessing script: ', preprocessing.script)
    source(file.path('munge', preprocessing.script), local = .TargetEnv)
  }
  return(my.project.info)
}

# Auxiliary functions for loading/unloading projects -------------------------

## Function to create directory if it doesn't exist yet
.provide.directory <- function(name) {
  is.dir <- file.info(name)$isdir
  if (is.na(is.dir) || !is.dir) {
    warning("Creating missing directory ", name)
    dir.create(name)
  }
}

## Function to check the project version against the package version
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

.package.version <- function() {
  as.character(read.dcf(system.file("DESCRIPTION", package = "ProjectTemplate"), fields = "Version"))
}

# Compare the variables (excluding functions) in the global env with a passed
# in string of names and return the difference
.var.diff.from <- function(given.var.list="", env=.TargetEnv) {
  # Get variables in target environment of determine if they are a function
  current.var.list <- sapply(ls(envir = env), function(x) is.function(get(x)))
  current.var.list <- names(current.var.list[current.var.list == FALSE])

  # return those not in list
  setdiff(current.var.list, given.var.list)
}
