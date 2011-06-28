load.project <- function()
{
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

  if (file.exists('lib'))
  {
    message('Autoloading helper functions')
    
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
      for (package.to.load in config[['libraries']])
      {
        message(paste(' Loading package:', package.to.load))
        if (!library(package.to.load, character.only = TRUE, logical.return = TRUE))
        {
          stop(paste('Failed to load package: ', package.to.load))
        }
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

    for (cache.file in cache.files)
    {
      for (extension in names(ProjectTemplate:::extensions.dispatch.table))
      {
        filename <- file.path('cache', cache.file)

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

    for (data.file in data.files)
    {
      for (extension in names(ProjectTemplate:::extensions.dispatch.table))
      {
        filename <- file.path('data', data.file)

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

          break()
        }
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
      message(paste(' Running preprocessing script:', preprocessing.script))
      source(file.path('munge', preprocessing.script))
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
    # Need to think about why this didn't work in the naive way.
    # Something about how `level<-` works.
    logfile(logger) <- file.path('logs', 'project.log')
    level(logger) <- log4r:::INFO
    assign('logger', logger, envir = .GlobalEnv)
  }
}
