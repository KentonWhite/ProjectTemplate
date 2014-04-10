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
  my.project.info <- list()

  message('Loading project configuration')

  config.path <- file.path('config', 'global.dcf')
  config <- if (file.exists(config.path)) {
    translate.dcf(file.path('config', 'global.dcf'))
  } else {
    warning('You are missing a configuration file: ', config.path, ' . Defaults will be used.')
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
  if (length(extra.entries) > 0) {
    warning('Your configuration contains the following unused entries: ',
            paste(extra.entries, collapse = ', '), '. These will be ignored.')
    config[extra.entries] <- NULL
  }

  config <- .normalize.config(config,
                              setdiff(names(default.config), "libraries"),
                              .boolean.cfg)
  config <- .normalize.config(config, "libraries",
                              function (x) strsplit(x, '\\s*,\\s*')[[1]])
  
  assign('config', config, envir = .TargetEnv)
  my.project.info$config <- config
  
  options(stringsAsFactors = config$as_factors)
  
  if (file.exists('lib'))
  {
    message('Autoloading helper functions')
    
    my.project.info$helpers <- c()
    
    helpers <- dir('lib', pattern = '[.][rR]$')
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

  if (config$load_libraries)
  {
    message('Autoloading packages')
    my.project.info$packages <- c()
    for (package.to.load in config$libraries)
    {
      message(paste(' Loading package:', package.to.load))
      require.package(package.to.load)
      my.project.info$packages <- c(my.project.info$packages, package.to.load)
    }
  }

  if (!config$data_loading && config$cache_loading)
  {
    message('Autoloading cache')
    
    # First, we load everything out of cache/.
    my.project.info$cache <- .load.cache()
  }
  
  if (config$data_loading)
  {
    message('Autoloading data')
    
    # First, we load everything out of cache/.
    my.project.info$cache <- .load.cache()

    # Then we consider loading things from data/.
    my.project.info$data <- .load.data()
  }

  if (config$data_tables)
  {
    require.package('data.table')
    
    for (data.set in my.project.info$data)
    {
      message('Converting data.frames to data.tables')
      
      if (class(get(data.set, envir = .TargetEnv)) == 'data.frame')
      {
        message(paste(' Translating data.frame:', data.set))
        assign(data.set,
               data.table(get(data.set, envir = .TargetEnv)),
               envir = .TargetEnv)
      }
    }
  }

  if (config$munging)
  {
    message('Munging data')
    for (preprocessing.script in sort(dir('munge', pattern = '[.][rR]$')))
    {
      message(paste(' Running preprocessing script:', preprocessing.script))
      source(file.path('munge', preprocessing.script))
    }
  }

  if (config$logging)
  {
    message('Initializing logger')
    require.package('log4r')

    logger <- create.logger()
    .provide.directory('logs')

    logfile(logger) <- file.path('logs', 'project.log')
    level(logger) <- log4r:::INFO
    assign('logger', logger, envir = .TargetEnv)
  }

  assign('project.info', my.project.info, envir = .TargetEnv)
  #assign('project.info', my.project.info, envir = parent.frame())
  #assign('project.info', my.project.info, envir = environment(create.project))
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
    
    for (extension in names(extensions.dispatch.table))
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

.load.data <- function() {
  .provide.directory('data')
  data.files <- dir('data', recursive = config$recursive_loading)
  data.files.loaded <- c()
  
  for (data.file in data.files)
  {
    filename <- file.path('data', data.file)
    
    for (extension in names(extensions.dispatch.table))
    {
      if (grepl(extension, data.file, ignore.case = TRUE, perl = TRUE))
      {
        variable.name <- clean.variable.name(sub(extension,
                                                 '',
                                                 data.file,
                                                 ignore.case = TRUE,
                                                 perl = TRUE))
        
        # If this variable already exists in cache, don't load it from data.
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

.provide.directory <- function(name) {
  is.dir <- file.info(name)$isdir
  if (is.na(is.dir) || !is.dir) {
    warning("Creating missing directory ", name)
    dir.create(name)
  }
}
