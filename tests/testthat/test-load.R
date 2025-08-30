context('Load project')

test_that('All elements have length 1', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  suppressMessages(load.project())
  expect_equal(unname(vapply(config, length, integer(1))), rep(1L, length(config)))
})

test_that('user commands fail when not in ProjectTemplate directory', {
        test_project <- tempfile('test_project')
        dir.create(test_project)
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)

        # Check load.project()
        expect_error(load.project())

        # Check clear.cache()
        expect_error(clear.cache())

        # Check cache()
        expect_error(cache())

        # Check reload.project()
        expect_error(reload.project())

        # Check reload.project()
        expect_error(test.project())

        # Check stub.tests()
        expect_error(stub.tests())

        # Check project.config()
        expect_error(project.config())

})

for (cache_file_format in cache_file_formats) {
  test_that('auto loaded data is cached by default', {
    test_project <- tempfile('test_project')
    suppressMessages(create.project(test_project))
    on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

    oldwd <- setwd(test_project)
    on.exit(setwd(oldwd), add = TRUE)

    set_cache_file_format(cache_file_format)

    # clear the global environment
    rm(list=ls(envir = .TargetEnv), envir = .TargetEnv)

    test_data <- tibble::as_tibble(data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40)))

    # save test data as a csv in the data directory
    write.csv(test_data, file="data/test.csv", row.names = FALSE)

    suppressMessages(load.project())

    # check that the cached file loads without error
    switch(
      cache_file_format,
      RData = expect_no_error(load("cache/test.RData", envir = environment())),
      qs = expect_no_error(qs::qload("cache/test.qs", env = environment()))
    )

    # and check that the loaded data from the cache is what we saved
    expect_equal(test, test_data)
  })

  test_that('auto loaded data is not cached when cached_loaded_data is FALSE', {
    test_project <- tempfile('test_project')
    suppressMessages(create.project(test_project))
    on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

    oldwd <- setwd(test_project)
    on.exit(setwd(oldwd), add = TRUE)

    set_cache_file_format(cache_file_format)

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
    switch(
      cache_file_format,
      RData = expect_error(suppressWarnings(load("cache/test.RData", envir = environment())), "cannot open the connection"),
      qs = expect_error(qs::qload("cache/test.qs", env = environment()), "Failed to open for reading")
    )
  })

  test_that('auto loaded data from an R script is cached correctly', {
    test_project <- tempfile('test_project')
    suppressMessages(create.project(test_project))
    on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

    oldwd <- setwd(test_project)
    on.exit(setwd(oldwd), add = TRUE)

    set_cache_file_format(cache_file_format)

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
    switch(
      cache_file_format,
      RData = {
        expect_no_error(load("cache/test_data12.RData", envir = environment()))
        expect_no_error(load("cache/test_data22.RData", envir = environment()))
      },
      qs = {
        expect_no_error(qs::qload("cache/test_data12.qs", env = environment()))
        expect_no_error(qs::qload("cache/test_data22.qs", env = environment()))
      }
    )

    # check that the other test variables have not been cached
    switch(
      cache_file_format,
      RData = {
        expect_error(suppressWarnings(load("cache/test_data11.RData", envir = environment())), "cannot open the connection")
        expect_error(suppressWarnings(load("cache/test_data21.RData", envir = environment())), "cannot open the connection")
      },
      qs = {
        expect_error(qs::qload("cache/test_data11.qs", env = environment()), "Failed to open for reading")
        expect_error(qs::qload("cache/test_data21.qs", env = environment()), "Failed to open for reading")
      }
    )
  })
}

test_that('ignored data files are not loaded', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # clear the global environment
  rm(list = ls(envir = .TargetEnv), envir = .TargetEnv)

  # Read the config data and set cache_loaded_data to FALSE

  config <- .read.config()

  expect_error(config$cache_loaded_data <- FALSE, NA)
  .save.config(config)

  # create some test data so the file can be loaded if not ignored
  test_data <- tibble::as_tibble(data.frame(Names = c("a", "b", "c"), Ages = c(20,30,40)))

  # write test data to files
  write.csv(test_data, file = 'data/test.csv', row.names = FALSE)
  dir.create('data/test')
  write.csv(test_data, file = 'data/test/test.csv', row.names = FALSE)

  # load the project and data with default settings,
  #  check that data/test.csv is loaded
  suppressMessages(load.project())
  expect_equal(test, test_data)

  # reload the project, now with recursive_loading
  rm(list = ls(envir = .TargetEnv), envir = .TargetEnv)
  suppressMessages(load.project(recursive_loading = TRUE))
  expect_equal(test, test_data)
  expect_equal(test.test, test_data)

  writeLines('\n', 'data/Thumbs.db') # Should trigger error
  # reload the project, now with an illegal Thumbs.db
  rm(list = ls(envir = .TargetEnv), envir = .TargetEnv)
  # The Thumbs.db is not a valid SQLite database so should raise an error
  expect_error(suppressWarnings(load.project(override.config = list(data_ignore = ''))))

  # reload the project, ignore *.csv
  rm(list = ls(envir = .TargetEnv), envir = .TargetEnv)
  suppressMessages(load.project(data_ignore = 'Thumbs.db, *.csv'))
  expect_false(exists("test", envir = .TargetEnv))
  expect_false(exists("test.test", envir = .TargetEnv))

  # reload the project, ignore *.csv with recursive loading
  rm(list = ls(envir = .TargetEnv), envir = .TargetEnv)
  suppressMessages(load.project(data_ignore = 'Thumbs.db, *.csv',
                                recursive_loading = TRUE))
  expect_false(exists("test", envir = .TargetEnv))
  expect_false(exists("test.test", envir = .TargetEnv))

  # reload the project, ignore test/*.csv with recursive loading
  rm(list = ls(envir = .TargetEnv), envir = .TargetEnv)
  suppressMessages(load.project(data_ignore = 'Thumbs.db, test/*.csv',
                                recursive_loading = TRUE))
  expect_equal(test, test_data)
  expect_false(exists("test.test", envir = .TargetEnv))

  # reload the project, ignore test/ with recursive loading
  rm(list = ls(envir = .TargetEnv), envir = .TargetEnv)
  suppressMessages(load.project(data_ignore = 'Thumbs.db, test/',
                                recursive_loading = TRUE))
  expect_equal(test, test_data)
  expect_false(exists("test.test", envir = .TargetEnv))


  # reload the project, ignore test/*.csv as a regular expression with recursive loading
  rm(list = ls(envir = .TargetEnv), envir = .TargetEnv)
  suppressMessages(load.project(data_ignore = 'Thumbs.db, /test/.*\\.csv/',
                                recursive_loading = TRUE))
  expect_equal(test, test_data)
  expect_false(exists("test.test", envir = .TargetEnv))

  # reload the project, ignore cached var_to_cache
  rm(list = ls(envir = .TargetEnv), envir = .TargetEnv)
  assign("var_to_cache", test_data, envir = .TargetEnv)
  cache("var_to_cache")
  rm(var_to_cache, envir = .TargetEnv)
  suppressMessages(load.project(data_ignore = 'Thumbs.db, var_to_cache'))
  expect_false(exists("var_to_cache", envir = .TargetEnv))

})

test_that('data is loaded as data_frame', {
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)

        # clear the global environment
        rm(list=ls(envir = .TargetEnv), envir = .TargetEnv)

        test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))

        # save test data as a csv in the data directory
        write.csv(test_data, file="data/test.csv", row.names = FALSE)

        config <- .new.config
        config$tables_type <- "data_frame"
        write.dcf(config, 'config/global.dcf')

        suppressMessages(load.project())

        # and check that the loaded data from the cache is what we saved
        expect_equal(test, test_data)
})

test_that('data is loaded as data_table', {
  skip_if_not_installed("data.table")

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # clear the global environment
  rm(list=ls(envir = .TargetEnv), envir = .TargetEnv)

  require('data.table')
  test_data <- data.table::data.table(data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40)))

  # save test data as a csv in the data directory
  write.csv(test_data, file="data/test.csv", row.names = FALSE)

  config <- .new.config
  config$tables_type <- "data_table"
  write.dcf(config, 'config/global.dcf')

  suppressMessages(load.project())

  # and check that the loaded data from the cache is what we saved
  expect_equal(test, test_data)
})

test_that('logs are written to a logs subdirectory',{
  skip_if_not_installed("log4r")

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  config <- .new.config
  config$logging <- TRUE
  write.dcf(config, 'config/global.dcf')
  dir.create("logs/test_logs") # Don't want to trigger warning - causes problems with CRAN

  # Create some R code and put in data directory
  CODE <- paste0(deparse(substitute({
    require.package('log4r')
    info(logger,"this is a test file")
  })), collapse ="\n")

  # save R code in the munge directory
  writeLines(CODE, "munge/test.R")

  #load the project and R code
  suppressMessages(load.project(logs_sub_dir="test_logs"))

  expect_false(file.exists(file.path("logs","project.log")))
  expect_true(file.exists(file.path("logs","test_logs","project.log")))

})

test_that('read from munge subdirectory',{
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Create some R code and put in munge subdirectory directory
  CODE <- paste0(deparse(substitute({
    test_data <- tibble::as_tibble(data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40)))
  })), collapse ="\n")

  dir.create(file.path("munge","test_munge"))
  writeLines(CODE, file.path("munge","test_munge","02-test_data.R")  )

  #load the project and R code
  suppressMessages(load.project(munge_sub_dir="test_munge"))

  expect_true(exists("test_data"))

})

test_that('pass munge files to run',{
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Create some R code and put in munge subdirectory directory
  CODE <- paste0(deparse(substitute({
    test_data_1 <- tibble::as_tibble(data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40)))
  })), collapse ="\n")

  writeLines(CODE, file.path("munge","01-test_data.R"))

  CODE <- paste0(deparse(substitute({
    test_data_2 <- tibble::as_tibble(data.frame(Names=c("d", "e", "f"), Ages=c(50,60,70)))
  })), collapse ="\n")

  writeLines(CODE, file.path("munge","02-test_data.R"))

  CODE <- paste0(deparse(substitute({
    test_data_3 <- tibble::as_tibble(data.frame(Names=c("d", "e", "f"), Ages=c(50,60,70)))
  })), collapse ="\n")

  writeLines(CODE, file.path("munge","03-test_data.R"))

  #load the project and R code
  suppressMessages(load.project(munge_files=c("02-test_data.R")))

  # expect_false(exists("test_data_1"))
  expect_true(exists("test_data_2"))
  # expect_false(exists("test_data_3"))

  suppressMessages(load.project(munge_files=c("03-test_data.R" ,"02-test_data.R")))
  # expect_false(exists("test_data_1"))
  expect_true(exists("test_data_2"))
  expect_true(exists("test_data_3"))

# ------------------------------------------------------------------------------
# Define a Python script and put in munge subdirectory directory
# ------------------------------------------------------------------------------
  python_code <- c(
    "print('  ')",
    "print('01-test_data.py start')",
    "",  # Empty line for readability
    "import csv",
    "import os",
    "# create a dictionary with the base package collections",
    "data = {'Names': [1, 2, 3], 'Ages': [20, 30, 40]}",
    "# Write data to CSV file in munge directory (adjust path if needed)",
    "with open('munge/test_data_py.csv', 'w', newline='') as f:",
    "    writer = csv.writer(f)",
    "    writer.writerows(zip(data['Names'], data['Ages']))",
    "",  # Empty line for readability
    "# Print data sum for testing purposes",
    "# print(data.sum())",
    "print('01-test_data.py finish')"
  )
# ------------------------------------------------------------------------------
# Write the Python code to a .py file
# ------------------------------------------------------------------------------
  writeLines(python_code, file.path("munge","01-test_data.py"))
# ------------------------------------------------------------------------------
# Check if python dataframe exists
# ------------------------------------------------------------------------------
  check_py_data <- c(
    "print('  ')",
    "print('02-test_data.py start')",
    "import collections",
    "import csv",
    "import os",
    "import sys",
# ------------------------------------------------------------------------------
    "with open('munge/test_data_py.csv', 'r') as f:",
    "    df_csv = csv.reader(f)",
    "    for row in df_csv:",
    "        print(row)",
# ------------------------------------------------------------------------------
    "with open('munge/write_test_data_py.csv', 'w', newline='') as f:",
    "    writer = csv.writer(f)",
    "    writer.writerows(zip(data['Names'], data['Ages']))",
# ------------------------------------------------------------------------------
    "",
    "subdirectory = 'munge'",
# ------------------------------------------------------------------------------
    "",
    "if 'subdirectory' in globals():",
    "    data = 'y'",
    "    print('Python data exists in the environment')",
    "else:",
    "    data = 'n'",
    "    print('Python data NOT in the environment')",
# ------------------------------------------------------------------------------
    "",
    "print(data)",
    "",
    "full_file_path = os.path.join(subdirectory, f'{data}.csv')",
    "open(full_file_path, 'w', newline='')",
# ------------------------------------------------------------------------------
    "",
    "print('02-test_data.py finish')"
# ------------------------------------------------------------------------------
  )
# ------------------------------------------------------------------------------
  writeLines(check_py_data, file.path( "munge", "02-test_data.py" ))
# ------------------------------------------------------------------------------
  suppressMessages(load.project())
# ------------------------------------------------------------------------------
# Check if python and R source file exists
# ------------------------------------------------------------------------------
  expect_true(file.exists(file.path("munge", "01-test_data.py")))
  expect_true(file.exists(file.path("munge", "01-test_data.R")))
  expect_true(file.exists(file.path("munge", "02-test_data.py")))
  expect_true(file.exists(file.path("munge", "02-test_data.R")))
# ------------------------------------------------------------------------------
# Check if CSV file exists (created by 01-test_data.py)
# ------------------------------------------------------------------------------
  expect_true(file.exists(file.path("munge", "test_data_py.csv")))
  expect_true(file.exists(file.path("munge", "write_test_data_py.csv")))
# ------------------------------------------------------------------------------
# validate if entry defined in python environment (created by 02-test_data.py)
# ------------------------------------------------------------------------------
  expect_true(file.exists(file.path( "munge", "y.csv")))
  expect_false(file.exists(file.path("munge", "n.csv")))
# ------------------------------------------------------------------------------
# Check if py_data is present in the current R environment
# ------------------------------------------------------------------------------
  expect_false("data" %in% ls(), "Python dataframe exists in the R environment")
# ------------------------------------------------------------------------------
})
