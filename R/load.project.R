#' Automatically load data and packages for a project.
#'
#' This function automatically load all of the data and packages used by
#' the project from which it is called.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#'
#' #load.project()
load.project <- function()
{
  project.info <- list()

  message('Loading project configuration')
  if (!file.exists(file.path('config', 'global.dcf')))
  {
    stop('You are missing a configuration file: config/global.dcf')
  }
  config <- ProjectTemplate:::translate.dcf(file.path('config', 'global.dcf'))
  if (is.null(config[['libraries']]))
  {
    warning('Your configuration file is missing an entry: libraries')
  }
  config[['libraries']] <- strsplit(config[['libraries']], '\\s*,\\s*')[[1]]
  assign('config', config, envir = .GlobalEnv)
  project.info[['config']] <- config
  
  if (! is.null(config[['as_factors']]) && config[['as_factors']] == 'off')
  {
    options(stringsAsFactors = FALSE)
  }
  
  if (file.exists('lib'))
  {
    message('Autoloading helper functions')
    
    project.info[['helpers']] <- c()
    
    for (helper.script in dir('lib'))
    {
      if (grepl('\\.R$', helper.script, ignore.case = TRUE))
      {
        for (deprecated.file in c('boot.R', 'load_data.R', 'load_libraries.R', 'preprocess_data.R', 'run_tests.R'))
        {
          if (grepl(deprecated.file, helper.script, ignore.case = TRUE))
          {
            warning(paste('Skipping deprecated file:', deprecated.file))
            next()
          }
        }
        message(paste(' Running helper script:', helper.script))
        source(file.path('lib', helper.script))
        project.info[['helpers']] <- c(project.info[['helpers']], helper.script)
      }
    }
  }

  if (is.null(config[['load_libraries']]))
  {
    warning('Your configuration file is missing an entry: load_libraries')
  }
  else
  {
    if (config[['load_libraries']] == 'on')
    {
      message('Autoloading packages')
      project.info[['packages']] <- c()
      for (package.to.load in config[['libraries']])
      {
        message(paste(' Loading package:', package.to.load))
        if (!library(package.to.load, character.only = TRUE, logical.return = TRUE))
        {
          stop(paste('Failed to load package: ', package.to.load))
        }
        project.info[['packages']] <- c(project.info[['packages']], package.to.load)
      }
    }
  }

  if (is.null(config[['data_loading']]))
  {
    warning('Your configuration file is missing an entry: data_loading')
  }
  if (config[['data_loading']] == 'on')
  {
    message('Autoloading data')
    
    # First, we load everything out of cache/.
    if (!file.exists('cache'))
    {
      stop('You are missing a directory: cache')
    }
    cache.files <- dir('cache')
    project.info[['cache']] <- c()
    
    for (cache.file in cache.files)
    {
      filename <- file.path('cache', cache.file)
      
      for (extension in names(ProjectTemplate:::extensions.dispatch.table))
      {
        if (grepl(extension, cache.file, ignore.case = TRUE, perl = TRUE))
        {
          variable.name <- ProjectTemplate:::clean.variable.name(sub(extension,
                                                   '',
                                                   cache.file,
                                                   ignore.case = TRUE,
                                                   perl = TRUE))

          # If this variable already exists in the global environment, don't load it from cache.
          if (variable.name %in% ls(envir = .GlobalEnv))
          {
            next()
          }
          
          message(paste(" Loading cached data set: ", variable.name, sep = ''))

          do.call(ProjectTemplate:::extensions.dispatch.table[[extension]],
                  list(cache.file,
                       filename,
                       variable.name))
          
          project.info[['cache']] <- c(project.info[['cache']], variable.name)
          
          break()
        }
      }
    }

    # Then we consider loading things from data/.
    if (!file.exists('data'))
    {
      stop('You are missing a directory: data')
    }
    data.files <- dir('data')
    project.info[['data']] <- c()

    for (data.file in data.files)
    {
      filename <- file.path('data', data.file)
      
      for (extension in names(ProjectTemplate:::extensions.dispatch.table))
      {
        if (grepl(extension, data.file, ignore.case = TRUE, perl = TRUE))
        {
          variable.name <- ProjectTemplate:::clean.variable.name(sub(extension,
                                                   '',
                                                   data.file,
                                                   ignore.case = TRUE,
                                                   perl = TRUE))

          # If this variable already exists in cache, don't load it from data.
          if (variable.name %in% ls(envir = .GlobalEnv))
          {
            next()
          }

          message(paste(" Loading data set: ", variable.name, sep = ''))

          do.call(ProjectTemplate:::extensions.dispatch.table[[extension]],
                  list(data.file,
                       filename,
                       variable.name))

          project.info[['data']] <- c(project.info[['data']], variable.name)
          
          break()
        }
      }
    }
  }

  if (! is.null(config[['data_tables']]) && config[['data_tables']] == 'on')
  {
    library('data.table')
    
    for (data.set in project.info[['data']])
    {
      message('Converting data.frames to data.tables')
      
      if (class(get(data.set, envir = .GlobalEnv)) == 'data.frame')
      {
        message(paste(' Translating data.frame:', data.set))
        assign(data.set,
               data.table(get(data.set, envir = .GlobalEnv)),
               envir = .GlobalEnv)
      }
    }
  }

  if (is.null(config[['munging']]))
  {
    warning('Your configuration file is missing an entry: munging')
  }
  if (config[['munging']] == 'on')
  {
    message('Munging data')
    for (preprocessing.script in sort(dir('munge')))
    {
      if (grepl('\\.R$', preprocessing.script, ignore.case = TRUE))
      {
        message(paste(' Running preprocessing script:', preprocessing.script))
        source(file.path('munge', preprocessing.script))
      }
    }
  }

  if (is.null(config[['logging']]))
  {
    warning('Your configuration file is missing an entry: logging')
  }
  if (config[['logging']] == 'on')
  {
    message('Initializing logger')
    library('log4r')
    logger <- create.logger()
    if (!file.exists('logs'))
    {
      dir.create('logs')
    }
    logfile(logger) <- file.path('logs', 'project.log')
    level(logger) <- log4r:::INFO
    assign('logger', logger, envir = .GlobalEnv)
  }

  assign('project.info', project.info, envir = .GlobalEnv)
  #assign('project.info', project.info, envir = parent.frame())
  #assign('project.info', project.info, envir = environment(ProjectTemplate:::create.project))
}
