context('Load project')

test_that('All elements have length 1', {
  # Create temporary project
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Set temporary project as working directory
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Clear the global environment
  clear()

  # Load new project and test variable length
  suppressMessages(load.project())
  expect_equal(unname(vapply(config, length, integer(1))), rep(1L, length(config)))
})

test_that('user commands fail when not in ProjectTemplate directory', {
  # Create empty temporary directory
  test_project <- tempfile('test_project')
  dir.create(test_project)
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Set temporary project as working directory
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Since there is not project contents all functions should fail
  expect_error(load.project())
  expect_error(clear.cache())
  expect_error(cache())
  expect_error(reload.project())
  expect_error(test.project())
  expect_error(stub.tests())
  expect_error(project.config())
})

test_that('auto loaded data is cached by default', {
  # Create temporary project
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Set temporary project as working directory
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Clear the global environment
  clear()

  # Create and save test data as a csv in the data directory
  test_data <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))
  write.csv(test_data, file = "data/test.csv", row.names = FALSE)

  suppressMessages(load.project())

  # Check that the cached file loads without error and with correct contents
  expect_error(load("cache/test.RData", envir = environment()), NA)
  expect_equal(test, test_data)
})

test_that('auto loaded data is not cached when cached_loaded_data is FALSE', {
  # Create temporary project
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Set temporary project as working directory
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Clear the global environment
  clear()

  # Create and save test data as a csv in the data directory
  test_data <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))
  write.csv(test_data, file = "data/test.csv", row.names = FALSE)

  # Read the config data and set cache_loaded_data to FALSE
  config <- read.dcf("config/global.dcf")
  expect_error(config$cache_loaded_data <- FALSE, NA)
  write.dcf(config, "config/global.dcf" )

  suppressMessages(load.project())

  # Check that the test variable has not been cached
  expect_false(file.exists("cache/test.RData"))
})

test_that('auto loaded data from an R script is cached correctly', {
  # Create temporary project
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Set temporary project as working directory
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Clear the global environment
  clear()

  # Create some variables in the global env that shouldn't be cached
  test_data11 <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))
  test_data21 <- data.frame(Names = c("a1", "b1", "c1"), Ages = c(20, 30, 40))

  # Create some R code and put in data directory
  CODE <- paste0(deparse(substitute({
    test_data12 <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))
    test_data22 <- data.frame(Names = c("a1", "b1", "c1"), Ages = c(20, 30, 40))
  })), collapse = "\n")
  writeLines(CODE, "data/test.R")

  # Load the project and R code
  suppressMessages(load.project())

  # Check that the test variables have been cached correctly
  expect_error(load("cache/test_data12.RData", envir = environment()), NA)
  expect_error(load("cache/test_data22.RData", envir = environment()), NA)

  # Check that the other test variables have not been cached
  expect_false(file.exists("cache/test_data11.RData"))
  expect_false(file.exists("cache/test_data21.RData"))
})

test_that('ignored data files are not loaded', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # clear the global environment
  clear()

  # # Read the config data and set cache_loaded_data to FALSE
  # config <- read.dcf("config/global.dcf")
  # expect_error(config$cache_loaded_data <- FALSE, NA)
  # write.dcf(config, "config/global.dcf" )

  # Create some test data so the file can be loaded if not ignored
  test_data <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))

  # Write test data to files
  writeLines('\n', 'data/Thumbs.db') # Should be ignored by default
  write.csv(test_data, file = 'data/test.csv', row.names = FALSE)
  dir.create('data/test')
  write.csv(test_data, file = 'data/test/test.csv', row.names = FALSE)

  # Load the project and data with default settings,
  #  check that data/test.csv is loaded
  suppressMessages(load.project())
  expect_equal(test, test_data)

  # Reload the project, now with recursive_loading
  clear()
  suppressMessages(load.project(override.config = list(recursive_loading = TRUE)))
  expect_equal(test, test_data)
  expect_equal(test.test, test_data)

  # Reload the project, now without ignoring files
  clear()
  # The Thumbs.db is not a valid SQLite database so should raise an error
  expect_error(suppressMessages(load.project(override.config = list(data_ignore = ''))),
               'not a database')

  # Reload the project, ignore *.csv
  clear()
  suppressMessages(load.project(override.config = list(data_ignore = 'Thumbs.db, *.csv')))
  expect_false(exists("test", envir = .TargetEnv))
  expect_false(exists("test.test", envir = .TargetEnv))

  # Reload the project, ignore *.csv with recursive loading
  clear()
  suppressMessages(load.project(override.config = list(data_ignore = 'Thumbs.db, *.csv',
                                                       recursive_loading = TRUE)))
  expect_false(exists("test", envir = .TargetEnv))
  expect_false(exists("test.test", envir = .TargetEnv))

  # Reload the project, ignore test/*.csv with recursive loading
  clear()
  suppressMessages(load.project(override.config = list(data_ignore = 'Thumbs.db, test/*.csv',
                                                       recursive_loading = TRUE)))
  expect_equal(test, test_data)
  expect_false(exists("test.test", envir = .TargetEnv))

  # Reload the project, ignore test/ with recursive loading
  clear()
  suppressMessages(load.project(override.config = list(data_ignore = 'Thumbs.db, test/',
                                                       recursive_loading = TRUE)))
  expect_equal(test, test_data)
  expect_false(exists("test.test", envir = .TargetEnv))


  # Reload the project, ignore test/*.csv as a regular expression with recursive loading
  clear()
  suppressMessages(load.project(override.config = list(data_ignore = 'Thumbs.db, /test/.*\\.csv/',
                                                       recursive_loading = TRUE)))
  expect_equal(test, test_data)
  expect_false(exists("test.test", envir = .TargetEnv))
})
