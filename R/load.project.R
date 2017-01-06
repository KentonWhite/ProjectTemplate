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
  project_name <- .stopifnotproject ("Please change to correct directory and re-run load.project()")
        
  my.project.info <- list()

  message(paste0('Project name: ', project_name))
  message('Loading project configuration')

  config <- .load.config(override.config)

  .check.version(config)

  assign('config', config, envir = .TargetEnv)
  my.project.info$config <- config

  options(stringsAsFactors = config$as_factors)

  if (config$load_libraries)
  {
    message('Autoloading packages')
    my.project.info$packages <- c()
    for (package.to.load in strsplit(config$libraries, '\\s*,\\s*')[[1]])
    {
      message(paste(' Loading package:', package.to.load))
      require.package(package.to.load)
      my.project.info$packages <- c(my.project.info$packages, package.to.load)
    }
  }

  if (config$logging)
  {
    message('Initializing logger')
    require.package('log4r')

    logger <- log4r::create.logger()
    .provide.directory('logs')

    log4r::logfile(logger) <- file.path('logs', 'project.log')
    log4r::level(logger) <- config$logging_level
    assign('logger', logger, envir = .TargetEnv)
  }

  if (file.exists('lib'))
  {
    message('Autoloading helper functions')

    my.project.info$helpers <- c()

    helpers <- dir('lib', pattern = '[.][rR]$')
    
    # force globals.R to be read first, if it exists
    if ("globals.R" %in% helpers) {
            helpers<-c("globals.R", helpers[!(helpers %in% "globals.R")])
    }
    
    deprecated.files <- intersect(
      helpers, c('boot.R', 'load_data.R', 'load_libraries.R',
                 'preprocess_data.R', 'run_tests.R'))
    if (length(deprecated.files) > 0) {
      warning(paste('Skipping deprecated files:',
                    paste(deprecated.files, collapse = ', ')))
    }

    for (helper.script in helpers)
    {
      message(paste(' Running helper script:', helper.script))
      source(file.path('lib', helper.script))
      my.project.info$helpers <- c(my.project.info$helpers, helper.script)
    }
  }

  # First, we load everything out of cache/.
  if (config$cache_loading)
  {
    message('Autoloading cache')

    my.project.info$cache <- .load.cache()
  }

  # Then we consider loading things from data/.
  
  # First save the variables already in the global env
  before.data.load <- .var.diff.from()
  
  if (config$data_loading)
  {
    message('Autoloading data')

    my.project.info$data <- .load.data(config$recursive_loading)
  }

  if (config$data_tables)
  {
    require.package('data.table')

    message('Converting data.frames to data.tables')

    .convert.to.data.table(my.project.info$data)
  }
  
  # If we have just loaded data from the data directory, cache it straight away
  # if the cache_loaded_data config is TRUE. 
  new.vars <- .var.diff.from(before.data.load)
  if (config$cache_loaded_data && (length(new.vars)>0))
  {
          sapply(new.vars, cache)
  }
  
  # update project.info$data with any additional datasets generated during autoload
  if (length(new.vars) > 0)
        my.project.info$data <- unique(c(my.project.info$data, new.vars))
  
  # remove any items in project.info$data which are not in the global environment
  remove <- setdiff(my.project.info$data, .var.diff.from())
  my.project.info$data <- my.project.info$data[! (my.project.info$data %in% remove)] 
  
 
  if (config$munging)
  {
    message('Munging data')
    for (preprocessing.script in sort(dir('munge', pattern = '[.][rR]$')))
    {
      message(paste(' Running preprocessing script:', preprocessing.script))
      source(file.path('munge', preprocessing.script))
    }
  }

  assign('project.info', my.project.info, envir = .TargetEnv)
}

.unload.project <- function() {
  suppressWarnings(rm(list = c("config", "logger", "project.info"), envir = .TargetEnv))
}


.load.data <- function(recursive) {
  .provide.directory('data')
  data.files <- dir('data', recursive = recursive)
  data.files.loaded <- c()

  for (data.file in data.files)
  {
    filename <- file.path('data', data.file)

    for (extension in ls(extensions.dispatch.table))
    {
      if (grepl(extension, data.file, ignore.case = TRUE, perl = TRUE))
      {
        variable.name <- clean.variable.name(sub(extension,
                                                 '',
                                                 data.file,
                                                 ignore.case = TRUE,
                                                 perl = TRUE))

        # If this variable already exists in global env, don't load it from data.
        if (variable.name %in% ls(envir = .TargetEnv))
        {
          next()
        }

        message(paste(" Loading data set: ", variable.name, sep = ''))

        do.call(extensions.dispatch.table[[extension]],
                list(data.file,
                     filename,
                     variable.name))

        data.files.loaded <- c(data.files.loaded, variable.name)

        break()
      }
    }
  }

  data.files.loaded
}

.convert.to.data.table <- function(data.sets) {
  .require.package("data.table")

  for (data.set in data.sets)
  {
    if (all(class(get(data.set, envir = .TargetEnv, inherits = FALSE)) == 'data.frame'))
    {
      message(paste(' Translating data.frame:', data.set))
      assign(data.set,
             data.table::data.table(get(data.set, envir = .TargetEnv, inherits = FALSE)),
             envir = .TargetEnv)
    }
  }
}

.provide.directory <- function(name) {
  is.dir <- file.info(name)$isdir
  if (is.na(is.dir) || !is.dir) {
    warning("Creating missing directory ", name)
    dir.create(name)
  }
}

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
        current.var.list <- names(current.var.list[current.var.list==FALSE])
        
        # return those not in list
        setdiff(current.var.list, given.var.list)
}
