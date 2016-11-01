#' Automatically load data and packages for a project.
#'
#' This function automatically load all of the data and packages used by
#' the project from which it is called.
#'
#' @param override.config Named list, allows overriding individual configuration
#'   items.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @seealso \code{\link{create.project}}, \code{\link{get.project}},
#'   \code{\link{cache.project}}, \code{\link{show.project}}
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{load.project()}
load.project <- function(override.config = NULL)
{
  this_dir <- .project.info(getwd())
  if (!this_dir$is.ProjectTemplate) {
          return(
          message(paste0(c(paste0("Current directory: ", basename(getwd()),
                                  " is not a ProjectTemplate directory"),
                         "Please change to correct directory and re-run load.project()"),
                         collapse = "\n")
                  )
          )
  }
        
  my.project.info <- list()

  message(paste0('Project name: ', this_dir$name))
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
  #assign('project.info', my.project.info, envir = parent.frame())
  #assign('project.info', my.project.info, envir = environment(create.project))
}

.unload.project <- function() {
  suppressWarnings(rm(list = c("config", "logger", "project.info"), envir = .TargetEnv))
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

.load.cache <- function() {
  .provide.directory('cache')
  cache.files <- dir('cache')
  cached.files <- c()

  for (cache.file in cache.files)
  {
    filename <- file.path('cache', cache.file)

    for (extension in ls(extensions.dispatch.table))
    {
      if (grepl(extension, cache.file, ignore.case = TRUE, perl = TRUE))
      {
        variable.name <- clean.variable.name(sub(extension,
                                                 '',
                                                 cache.file,
                                                 ignore.case = TRUE,
                                                 perl = TRUE))

        # If this variable already exists in the global environment, don't load it from cache.
        if (variable.name %in% ls(envir = .TargetEnv))
        {
          next()
        }

        message(paste(" Loading cached data set: ", variable.name, sep = ''))

        do.call(extensions.dispatch.table[[extension]],
                list(cache.file,
                     filename,
                     variable.name))

        cached.files <- c(cached.files, variable.name)

        break()
      }
    }
  }

  cached.files
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

.config.path <- file.path('config', 'global.dcf')

.load.config <- function(override.config = NULL) {
  config <- if (file.exists(.config.path)) {
    translate.dcf(.config.path)
  } else {
    warning('You are missing a configuration file: ', .config.path, ' . Defaults will be used.')
    default.config
  }

  missing.entries <- setdiff(names(default.config), names(config))
  if (length(missing.entries) > 0) {
    warning('Your configuration file is missing the following entries: ',
            paste(missing.entries, collapse = ', '), '. Defaults will be used.')
    config[missing.entries] <- default.config[missing.entries]
  }

  if (length(override.config) > 0) {
    config[names(override.config)] <- override.config
  }

  extra.entries <- setdiff(names(config), names(default.config))
  extra.entries <- grep("^[^#]", extra.entries, value = TRUE)
  if (length(extra.entries) > 0) {
    warning('Your configuration contains the following unused entries: ',
            paste(extra.entries, collapse = ', '), '. These will be ignored.')
    config[extra.entries] <- NULL
  }

  config <- .normalize.config(config,
                              setdiff(names(default.config), c("version", "libraries", "logging_level")),
                              .boolean.cfg)
  

  config
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

# files that determine whether a directory is a ProjectTemplate project
.mandatory.files <- c("config/global.dcf", "cache", "data")

# List of information about a project
.project.info <- function (path=getwd()) {
        is.ProjectTemplate <- .is.ProjectTemplate(path)
        name <- ifelse(is.ProjectTemplate, basename(path), "")
        list(is.ProjectTemplate=is.ProjectTemplate, name=name) 
}

# Test whether a given path is a ProjectTemplate project
.is.ProjectTemplate <- function (path=getwd()) {
        check_files <- file.path(path, .mandatory.files)
        if(sum(file.exists(check_files))==length(check_files)) return(TRUE)
        return(FALSE)
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


