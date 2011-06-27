load.project <- function()
{
  message('Loading project configuration')
  config <- ProjectTemplate:::translate.dcf(file.path('config', 'global.dcf'))
  config[['libraries']] <- strsplit(config[['libraries']], '\\s*,\\s*')[[1]]
  assign('config', config, envir = .GlobalEnv)

  if (file.exists(file.path('lib', 'utilities.R')))
  {
    message('Autoloading utility functions')
    source(file.path('lib', 'utilities.R'))
  }

  if (config[['load_libraries']] == 'on')
  {
    message('Autoloading libraries')
    for (library.to.load in config[['libraries']])
    {
      message(paste(' Loading library:', library.to.load))
      library(library.to.load, character.only = TRUE)
    }
  }

  message('Autoloading data')

  extensions.dispatch.table <- list("\\.csv$" = ProjectTemplate:::csv.reader,
                                    "\\.csv.bz2$" = ProjectTemplate:::csv.reader,
                                    "\\.csv.zip$" = ProjectTemplate:::csv.reader,
                                    "\\.csv.gz$" = ProjectTemplate:::csv.reader,
                                    "\\.tsv$" = ProjectTemplate:::tsv.reader,
                                    "\\.tsv.bz2$" = ProjectTemplate:::tsv.reader,
                                    "\\.tsv.zip$" = ProjectTemplate:::tsv.reader,
                                    "\\.tsv.gz$" = ProjectTemplate:::tsv.reader,
                                    "\\.tab$" = ProjectTemplate:::tsv.reader,
                                    "\\.tab.bz2$" = ProjectTemplate:::tsv.reader,
                                    "\\.tab.zip$" = ProjectTemplate:::tsv.reader,
                                    "\\.tab.gz$" = ProjectTemplate:::tsv.reader,
                                    "\\.wsv$" = ProjectTemplate:::wsv.reader,
                                    "\\.wsv.bz2$" = ProjectTemplate:::wsv.reader,
                                    "\\.wsv.zip$" = ProjectTemplate:::wsv.reader,
                                    "\\.wsv.gz$" = ProjectTemplate:::wsv.reader,
                                    "\\.txt$" = ProjectTemplate:::wsv.reader,
                                    "\\.txt.bz2$" = ProjectTemplate:::wsv.reader,
                                    "\\.txt.zip$" = ProjectTemplate:::wsv.reader,
                                    "\\.txt.gz$" = ProjectTemplate:::wsv.reader,
                                    "\\.Rdata$" = ProjectTemplate:::rdata.reader,
                                    "\\.rda$" = ProjectTemplate:::rdata.reader,
                                    "\\.R$" = ProjectTemplate:::r.reader,
                                    "\\.r$" = ProjectTemplate:::r.reader,
                                    "\\.url$" = ProjectTemplate:::url.reader,
                                    "\\.sql$" = ProjectTemplate:::sql.reader,
                                    "\\.xls$" = ProjectTemplate:::xls.reader,
                                    "\\.xlsx$" = ProjectTemplate:::xlsx.reader,
                                    "\\.sav$" = ProjectTemplate:::spss.reader,
                                    "\\.dta$" = ProjectTemplate:::stata.reader,
                                    "\\.arff$" = ProjectTemplate:::arff.reader,
                                    "\\.dbf$" = ProjectTemplate:::dbf.reader,
                                    "\\.rec$" = ProjectTemplate:::epiinfo.reader,
                                    "\\.mtp$" = ProjectTemplate:::mtp.reader,
                                    "\\.m$" = ProjectTemplate:::octave.reader,
                                    "\\.sys$" = ProjectTemplate:::systat.reader,
                                    "\\.syd$" = ProjectTemplate:::systat.reader,
                                    "\\.sas$" = ProjectTemplate:::xport.reader,
                                    "\\.xport$" = ProjectTemplate:::xport.reader)

  # First, we load everything out of cache/.
  cache.files <- dir('cache')

  for (cache.file in cache.files)
  {
    for (extension in names(extensions.dispatch.table))
    {
      filename <- file.path('cache', cache.file)

      if (grepl(extension, cache.file, ignore.case = TRUE, perl = TRUE))
      {
        variable.name <- ProjectTemplate:::clean.variable.name(sub(extension,
                                                 '',
                                                 cache.file,
                                                 ignore.case = TRUE,
                                                 perl = TRUE))

        message(paste(" Loading cached data set: ", variable.name, sep = ''))

        do.call(extensions.dispatch.table[[extension]],
                list(cache.file,
                     filename,
                     variable.name))

        break()
      }
    }
  }

  # Then we consider loading things from data/.
  if (config[['data_loading']] == 'on')
  {
    data.files <- dir('data')

    for (data.file in data.files)
    {
      for (extension in names(extensions.dispatch.table))
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

          do.call(extensions.dispatch.table[[extension]],
                  list(data.file,
                       filename,
                       variable.name))

          break()
        }
      }
    }
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

  if (config[['logging']] == 'on')
  {
    message('Initializing logger')
    library('log4r')
    # Need to think about why this didn't work in the naive way.
    # Something about how `level<-` works.
    logger <- create.logger()
    logfile(logger) <- file.path('logs', 'project.log')
    level(logger) <- log4r:::INFO
    assign('logger', logger, envir = .GlobalEnv)
  }
}
