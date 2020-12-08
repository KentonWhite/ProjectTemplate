context("qs cache file format")

qsCacheFileFormat <- function() {
  config <- .read.config()
  config$cache_file_format <- "qs"
  .save.config(config)
}

#### from test-cache.R ####
test_that('re-caching is skipped when a cached variable hasnt changed', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  qsCacheFileFormat()

  var_to_cache <- "xxxx"
  test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
  assign(var_to_cache, test_data, envir = .TargetEnv)

  # Create initial cached version
  cache(var_to_cache, CODE = NULL, depends = NULL)
  initial_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".qs")))$mtime

  # wait two seconds
  Sys.sleep(2)

  # Remove it from Global Environment
  rm(list=var_to_cache, envir = .TargetEnv)

  # Load up from cache and attempt to re-cache
  suppressMessages(load.project())
  expect_message(cache(var_to_cache, CODE = NULL, depends = NULL),
                 "Skipping cache update for")

  # Check that modification time hasn't changed
  new_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".qs")))$mtime

  expect_equal(initial_mtime, new_mtime)

  tidy_up()
})

test_that('re-caching is done again when a cached variable has changed', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  qsCacheFileFormat()

  var_to_cache <- "xxxx"
  test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
  assign(var_to_cache, test_data, envir = .TargetEnv)

  # Create initial cached version
  cache(var_to_cache, CODE = NULL, depends = NULL)
  initial_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".qs")))$mtime

  # wait two seconds
  Sys.sleep(2)

  # Remove it from Global Environment
  rm(list=var_to_cache, envir = .TargetEnv)

  # Load up from cache
  suppressMessages(load.project())

  # change the variable and attempt to re-cache
  test_data2 <- data.frame(Names=c("aaa", "b", "c"), Ages=c(20,30,40))
  assign(var_to_cache, test_data2, envir = .TargetEnv)

  expect_message(cache(var_to_cache, CODE = NULL, depends = NULL),
                 "Updating existing cache entry from global environment")

  # Check that modification time has changed
  new_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".qs")))$mtime
  expect_false(isTRUE(all.equal(initial_mtime, new_mtime)))

  # Reload and check that re-cached value is different
  rm(list=var_to_cache, envir = .TargetEnv)
  suppressMessages(load.project())

  expect_false(isTRUE(all.equal(get(var_to_cache, envir = .TargetEnv) , test_data)))

  tidy_up()
})

test_that('re-caching fails with correct message if cached variable is not in global env', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  qsCacheFileFormat()

  var_to_cache <- "xxxx"
  test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
  assign(var_to_cache, test_data, envir = .TargetEnv)

  # Create initial cached version
  cache(var_to_cache, CODE = NULL, depends = NULL)
  initial_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".qs")))$mtime

  # wait two seconds
  Sys.sleep(2)

  # Remove it from Global Environment
  rm(list=var_to_cache, envir = .TargetEnv)

  # Load up from cache
  suppressMessages(load.project())

  # And remove it from Global Environment again
  rm(list=var_to_cache, envir = .TargetEnv)

  expect_message(cache(var_to_cache, CODE = NULL, depends = NULL),
                 "Unable to update cache for")

  # Check that modification time hasn't changed
  new_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".qs")))$mtime
  expect_equal(initial_mtime, new_mtime)

  tidy_up()
})

test_that('re-caching a variable created from CODE only happens if code changes, not comments or white space', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  qsCacheFileFormat()

  var_to_cache <- "xxxx"
  test_data <- data.frame(Names=c("a", "b", "c"),
                          Ages=c(20000000,300,400))

  # Create a cached version created from CODE
  expect_message(cache(var_to_cache, depends = NULL, CODE = {
    data.frame(Names=c("a", "b", "c"),
               Ages=c(200,300,400))
  }),
  "Creating cache entry from CODE")

  initial_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".qs")))$mtime

  # wait two seconds
  Sys.sleep(2)

  # Remove it from Global Environment (rm will fail if it's not created from CODE)
  expect_error(rm(list=var_to_cache, envir = .TargetEnv), NA)

  # Load up from cache again
  suppressMessages(load.project())

  # re-cache, this time adding some comments and whitespace, but not changing code
  # should skip re-caching
  expect_message(cache(var_to_cache, depends = NULL, CODE = {
    #  New comments add in
    data.frame(Names=c("a", "b", "c"),
               Ages=c(200,300,400))    # but code remains the same

    # extra new lines added for good measure
  }),
  "Skipping cache update for ")

  # Check that modification time hasn't changed
  new_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".qs")))$mtime

  expect_equal(initial_mtime, new_mtime)

  # re-cache agin, keeping the comments and whitespace, but changing the code
  expect_message(cache(var_to_cache, depends = NULL, CODE = {
    #  New comments add in
    data.frame(Names=c("a", "b", "c"),
               Ages=c(20000000,300,400))    # but code remains the same

    # extra new lines added for good measure
  }),
  "Updating existing cache entry from CODE")

  # Check that modification time has also changed
  new_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".qs")))$mtime
  expect_false(isTRUE(all.equal(initial_mtime, new_mtime)))

  # Finally check that the new code evaluated correctly
  expect_equal(get(var_to_cache, envir = .TargetEnv) , test_data)

  tidy_up()
})

#### from test-load.R ####
test_that('auto loaded data is cached by default', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  qsCacheFileFormat()

  # clear the global environment
  rm(list=ls(envir = .TargetEnv), envir = .TargetEnv)

  test_data <- tibble::as_tibble(data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40)))

  # save test data as a csv in the data directory
  write.csv(test_data, file="data/test.csv", row.names = FALSE)

  suppressMessages(load.project())

  # check that the cached file loads without error
  expect_error(qs::qload("cache/test.qs", env = environment()), NA)

  # and check that the loaded data from the cache is what we saved
  expect_equal(test, test_data)
})

test_that('auto loaded data is not cached when cached_loaded_data is FALSE', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  qsCacheFileFormat()

  # clear the global environment
  rm(list=ls(envir = .TargetEnv), envir = .TargetEnv)

  test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))

  # save test data as a csv in the data directory
  write.csv(test_data, file="data/test.csv", row.names = FALSE)

  # Read the config data and set cache_loaded_data to FALSE
  config <- .read.config()
  expect_error(config$cache_loaded_data <- FALSE, NA)
  .save.config(config)

  suppressMessages(load.project())

  # check that the the test variable has not been cached
  expect_error(suppressWarnings(qs::qload("cache/test.qs", env = environment())),
               "Failed to open cache/test.qs. Check file path.")
})

test_that('auto loaded data from an R script is cached correctly', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  qsCacheFileFormat()

  # clear the global environment
  rm(list=ls(envir = .TargetEnv), envir = .TargetEnv)

  # create some variables in the global env that shouldn't be cached
  test_data11 <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
  test_data21 <- data.frame(Names=c("a1", "b1", "c1"), Ages=c(20,30,40))

  # Create some R code and put in data directory
  CODE <- paste0(deparse(substitute({
    test_data12 <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
    test_data22 <- data.frame(Names=c("a1", "b1", "c1"), Ages=c(20,30,40))
  })), collapse ="\n")

  # save R code in the data directory
  writeLines(CODE, "data/test.R")

  # load the project and R code
  suppressMessages(load.project())

  # check that the test variables have been cached correctly
  expect_error(qs::qload("cache/test_data12.qs", env = environment()), NA)
  expect_error(qs::qload("cache/test_data22.qs", env = environment()), NA)

  # check that the other test variables have not been cached
  expect_error(suppressWarnings(qs::qload("cache/test_data11.qs", env = environment())),
               "Failed to open cache/test_data11.qs. Check file path.")
  expect_error(suppressWarnings(qs::qload("cache/test_data21.qs", env = environment())),
               "Failed to open cache/test_data21.qs. Check file path.")
})

#### from test-migration.R ####
test_that('projects without the cached_loaded_data config have their migrated config set to FALSE ', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  qsCacheFileFormat()

  # Read the config data and remove the cache_loaded_data flag
  config <- .read.config()
  expect_error(config$cache_loaded_data <- NULL, NA)
  .save.config(config)

  # should get a warning because of the missing cache_loaded_data
  expect_warning(suppressMessages(load.project()), "missing the following entries")

  test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))

  # save test data as a csv in the data directory
  write.csv(test_data, file="data/test.csv", row.names = FALSE)

  # run load.project again and check that the the test variable has not been cached
  # because the default should be FALSE if the cache_loaded_data is missing before migrate.project
  # is called
  expect_warning(suppressMessages(load.project()), "missing the following entries: cache_loaded_data")
  expect_error(suppressWarnings(qs::qload("cache/test.qs", env = environment())),
               "Failed to open cache/test.qs. Check file path.")

  # Migrate the project
  expect_message(migrate.project(), "new config item called cache_loaded_data")

  # Read the config data and check cached_loaded_data is FALSE
  config <- .read.config()
  expect_equal(config$cache_loaded_data, FALSE)

  # Should be a clean load.project
  expect_warning(suppressMessages(load.project()), NA)

  # check that the the test variable has not been cached
  expect_error(suppressWarnings(qs::qload("cache/test.qs", env = environment())),
               "Failed to open cache/test.qs. Check file path.")
})
