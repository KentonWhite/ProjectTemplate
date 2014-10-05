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

  config <- .load.config(override.config)

  .check.version(config)

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
    for (package.to.load in strsplit(config$libraries, '\\s*,\\s*')[[1]])
    {
      message(paste(' Loading package:', package.to.load))
      require.package(package.to.load)
      my.project.info$packages <- c(my.project.info$packages, package.to.load)
    }
  }

  # First, we load everything out of cache/.
  if (config$cache_loading)
  {
    message('Autoloading cache')

    my.project.info$cache <- .load.cache()
  }

  # Then we consider loading things from data/.
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
    .require.package('log4r')

    logger <- log4r::create.logger()
    .provide.directory('logs')

    log4r::logfile(logger) <- file.path('logs', 'project.log')
    log4r::level(logger) <- "INFO"
    assign('logger', logger, envir = .TargetEnv)
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

.convert.to.data.table <- function(data.sets) {
  .require.package("data.table")

  for (data.set in data.sets)
  {
    if (all(class(get(data.set, envir = .TargetEnv)) == 'data.frame'))
    {
      message(paste(' Translating data.frame:', data.set))
      assign(data.set,
             data.table::data.table(get(data.set, envir = .TargetEnv)),
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

.load.config <- function(override.config = NULL) {
  config.path <- file.path('config', 'global.dcf')
  config <- if (file.exists(config.path)) {
    translate.dcf(config.path)
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
  extra.entries <- grep("^[^#]", extra.entries, value = TRUE)
  if (length(extra.entries) > 0) {
    warning('Your configuration contains the following unused entries: ',
            paste(extra.entries, collapse = ', '), '. These will be ignored.')
    config[extra.entries] <- NULL
  }

  config <- .normalize.config(config,
                              setdiff(names(default.config), c("version", "libraries")),
                              .boolean.cfg)

  config
}

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
