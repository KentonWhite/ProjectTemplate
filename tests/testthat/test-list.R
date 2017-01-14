context('List data')

temp_csv_file <- function(dir = '') {
  gsub('^/', '', tempfile(pattern = "file", tmpdir = dir, fileext = ".csv"))
}

test_that('available data is listed correctly with default configuration', {
  # Create temporary project
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Set temporary project as working directory
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Clear the global environment
  clear()

  # Create some test data so the file can be loaded if not ignored
  test_data <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))

  # Build two temporary filenames, strip leading /
  test_file1 <- temp_csv_file()
  test_file2 <- temp_csv_file(dir = 'test')

  # Write test data to files
  write.csv(test_data, file = file.path('data', test_file1), row.names = FALSE)
  dir.create('data/test')
  write.csv(test_data, file = file.path('data', test_file2), row.names = FALSE)

  # Check if list.data can be called and returns a data.frame
  expect_error(data.files <- list.data(), NA)
  expect_true(is.data.frame(data.files))

  # Check data.frame has a character variable "filename"
  expect_true("filename" %in% names(data.files))
  expect_true(class(data.files$filename) == "character")

  # Check data.frame has a character variable "varname"
  expect_true("varname" %in% names(data.files))
  expect_true(class(data.files$varname) == "character")

  # Check data.frame has a character variable "reader"
  expect_true("reader" %in% names(data.files))
  expect_true(class(data.files$reader) == "character")

  # Check data.frame has a logical variable "is_ignored"
  expect_true("is_ignored" %in% names(data.files))
  expect_true(class(data.files$is_ignored) == "logical")

  # Check data.frame has a logical variable "is_directory"
  expect_true("is_directory" %in% names(data.files))
  expect_true(class(data.files$is_directory) == "logical")

  # Check data.frame has a logical variable "is_cached"
  expect_true("is_cached" %in% names(data.files))
  expect_true(class(data.files$is_cached) == "logical")

  # Check data.frame has a logical variable "cache_only"
  expect_true("cache_only" %in% names(data.files))
  expect_true(class(data.files$cache_only) == "logical")

  # Check if data.frame has three rows with default config:
  #   - fileXXXXX.csv (test_file1, not ignored, varname: fileXXXXX, reader: csv.reader)
  #   - README.md (not ignored, varname: "", reader: "")
  #   - test (subdirectory, not ignored, varname: "", reader: "")
  expect_true(nrow(data.files) == 3)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', 'test'),
    varname = c(gsub('.csv', '', test_file1), "", ""),
    reader = c('csv.reader', "", ""),
    is_ignored = c(FALSE, FALSE, FALSE),
    is_directory = c(FALSE, FALSE, TRUE),
    is_cached = c(FALSE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$varname, test.df$varname)
  expect_equal(data.files$reader, test.df$reader)
  expect_equal(data.files$is_ignored, test.df$is_ignored)
  expect_equal(data.files$is_directory, test.df$is_directory)
  expect_equal(data.files$is_cached, test.df$is_cached)
  expect_equal(data.files$cache_only, test.df$cache_only)
})

test_that('available data is listed correctly with recursive_loading = TRUE', {
  # Create temporary project
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Set temporary project as working directory
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Read the config data and set cache_loaded_data to FALSE
  config <- .read.config()
  expect_error(config$recursive_loading <- TRUE, NA)
  .save.config(config)

  # Create some test data so the file can be loaded if not ignored
  test_data <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))

  # Build two temporary filenames, strip leading /
  test_file1 <- temp_csv_file()
  test_file2 <- temp_csv_file(dir = 'test')

  # Write test data to files
  write.csv(test_data, file = file.path('data', test_file1), row.names = FALSE)
  dir.create('data/test')
  write.csv(test_data, file = file.path('data', test_file2), row.names = FALSE)

  # Setup test data.frame
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', test_file2),
    varname = c(gsub('.csv', '', test_file1),
                "",
                gsub('/', '.', gsub('.csv', '', test_file2))),
    reader = c("csv.reader", "", "csv.reader"),
    is_ignored = c(FALSE, FALSE, FALSE),
    is_directory = c(FALSE, FALSE, FALSE),
    is_cached = c(FALSE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  # Check if list.data can be called and returns a data.frame
  expect_error(data.files <- list.data(), NA)

  # Check if data.frame has three rows with default config:
  #   - fileXXXXX.csv (test_file1)
  #   - README.md
  #   - test/fileYYYYYY.csv (test_file2)
  expect_true(nrow(data.files) == 3)
  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$varname, test.df$varname)
  expect_equal(data.files$reader, test.df$reader)
  expect_equal(data.files$is_directory, test.df$is_directory)
})

test_that('available data is listed correctly with data_ignore', {
  # Create temporary project
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Set temporary project as working directory
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Create some test data so the file can be loaded if not ignored
  test_data <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))

  # Build two temporary filenames, strip leading /
  test_file1 <- temp_csv_file()
  test_file2 <- temp_csv_file(dir = 'test')

  # Write test data to files
  write.csv(test_data, file = file.path('data', test_file1), row.names = FALSE)
  dir.create('data/test')
  write.csv(test_data, file = file.path('data', test_file2), row.names = FALSE)
  # Write an empty Thumbs.db that cannot be loaded by RSQLite
  writeLines('\n', file.path('data', 'Thumbs.db'))

  # Check if data.frame has four rows with default config:
  #   - fileXXXXX.csv (test_file1, not ignored)
  #   - README.md (not ignored)
  #   - test (subdirectory, not ignored)
  #   - Thumbs.db (ignored)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', 'test', 'Thumbs.db'),
    varname = c(gsub('.csv', '', test_file1), "", "", ""),
    reader = c("csv.reader", "", "", ""),
    is_ignored = c(FALSE, FALSE, FALSE, FALSE),
    is_directory = c(FALSE, FALSE, TRUE, FALSE),
    is_cached = c(FALSE, FALSE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  expect_error(data.files <- list.data(), NA)
  expect_true(nrow(data.files) == 4)
  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$is_ignored, test.df$is_ignored)

  # Check empty data_ignore:
  #   - fileXXXXX.csv (test_file1, not ignored)
  #   - README.md (not ignored)
  #   - test/fileYYYYY.csv (test_file2, not ignored)
  #   - Thumbs.db (not ignored)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', test_file2, 'Thumbs.db'),
    varname = c(gsub('.csv', '', test_file1),
                "",
                gsub('/', '.', gsub('.csv', '', test_file2)),
                ""),
    reader = c("csv.reader", "", "csv.reader", ""),
    is_ignored = c(FALSE, FALSE, FALSE, FALSE),
    is_directory = c(FALSE, FALSE, FALSE, FALSE),
    is_cached = c(FALSE, FALSE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  override.config <- list(data_ignore = '',
                          recursive_loading = TRUE)
  expect_error(data.files <- list.data(override.config = override.config), NA)
  expect_true(nrow(data.files) == 4)
  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$is_ignored, test.df$is_ignored)

  # Check wildcard ignore "*.csv":
  #   - fileXXXXX.csv (test_file1, ignored)
  #   - README.md (not ignored)
  #   - test (subdirectory, not ignored)
  #   - Thumbs.db (not ignored)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', 'test', 'Thumbs.db'),
    varname = c(gsub('.csv', '', test_file1), "", "", ""),
    reader = c("csv.reader", "", "", ""),
    is_ignored = c(TRUE, FALSE, FALSE, FALSE),
    is_directory = c(FALSE, FALSE, TRUE, FALSE),
    is_cached = c(FALSE, FALSE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  override.config <- list(data_ignore = '*.csv')
  expect_error(data.files <- list.data(override.config = override.config), NA)
  expect_true(nrow(data.files) == 4)
  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$is_ignored, test.df$is_ignored)

  # Check wildcard ignore "*.csv" with recursive loading on:
  #   - fileXXXXX.csv (test_file1, ignored)
  #   - README.md (not ignored)
  #   - test/fileYYYYY.csv (test_file2, not ignored)
  #   - Thumbs.db (not ignored)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', test_file2, 'Thumbs.db'),
    varname = c(gsub('.csv', '', test_file1),
                "",
                gsub('/', '.', gsub('.csv', '', test_file2)),
                ""),
    reader = c("csv.reader", "", "csv.reader", ""),
    is_ignored = c(TRUE, FALSE, TRUE, FALSE),
    is_directory = c(FALSE, FALSE, FALSE, FALSE),
    is_cached = c(FALSE, FALSE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  override.config <- list(data_ignore = '*.csv', recursive_loading = TRUE)
  expect_error(data.files <- list.data(override.config = override.config), NA)
  expect_true(nrow(data.files) == 4)
  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$is_ignored, test.df$is_ignored)

  # Check regular expression ignore "^\w*.csv", only match csv in data, not in
  #   subdirectories:
  #   - fileXXXXX.csv (test_file1, ignored)
  #   - README.md (not ignored)
  #   - test/fileYYYYY.csv (test_file2, not ignored)
  #   - Thumbs.db (not ignored)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', test_file2, 'Thumbs.db'),
    varname = c(gsub('.csv', '', test_file1),
                "",
                gsub('/', '.', gsub('.csv', '', test_file2)),
                ""),
    reader = c("csv.reader", "", "csv.reader", ""),
    is_ignored = c(TRUE, FALSE, FALSE, FALSE),
    is_directory = c(FALSE, FALSE, FALSE, FALSE),
    is_cached = c(FALSE, FALSE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  override.config <- list(data_ignore = '/^\\w*\\.csv/',
                          recursive_loading = TRUE)
  expect_error(data.files <- list.data(override.config = override.config), NA)
  expect_true(nrow(data.files) == 4)
  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$is_ignored, test.df$is_ignored)

  # Check combination literal filename "Thumbs.db" and regular expression
  #   ignore "^\w*.csv", only match csv in data, not in subdirectories:
  #   - fileXXXXX.csv (test_file1, ignored)
  #   - README.md (not ignored)
  #   - test/fileYYYYY.csv (test_file2, not ignored)
  #   - Thumbs.db (ignored)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', test_file2, 'Thumbs.db'),
    varname = c(gsub('.csv', '', test_file1),
                "",
                gsub('/', '.', gsub('.csv', '', test_file2)),
                ""),
    reader = c("csv.reader", "", "csv.reader", ""),
    is_ignored = c(TRUE, FALSE, FALSE, TRUE),
    is_directory = c(FALSE, FALSE, FALSE, FALSE),
    is_cached = c(FALSE, FALSE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  override.config <- list(data_ignore = 'Thumbs.db, /^\\w*\\.csv/',
                          recursive_loading = TRUE)
  expect_error(data.files <- list.data(override.config = override.config), NA)
  expect_true(nrow(data.files) == 4)
  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$is_ignored, test.df$is_ignored)

  # Check extra comma in combination literal filename "Thumbs.db" and regular
  #   expression ignore "^\w*\.csv", only match csv in data, not in
  #   subdirectories:
  #   - fileXXXXX.csv (test_file1, ignored)
  #   - README.md (not ignored)
  #   - test/fileYYYYY.csv (test_file2, not ignored)
  #   - Thumbs.db (ignored)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', test_file2, 'Thumbs.db'),
    varname = c(gsub('.csv', '', test_file1),
                "",
                gsub('/', '.', gsub('.csv', '', test_file2)),
                ""),
    reader = c("csv.reader", "", "csv.reader", ""),
    is_ignored = c(TRUE, FALSE, FALSE, TRUE),
    is_directory = c(FALSE, FALSE, FALSE, FALSE),
    is_cached = c(FALSE, FALSE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  override.config <- list(data_ignore = 'Thumbs.db,,/^\\w*\\.csv/',
                          recursive_loading = TRUE)
  expect_error(data.files <- list.data(override.config = override.config), NA)
  expect_true(nrow(data.files) == 4)
  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$is_ignored, test.df$is_ignored)
})

test_that('cached data is listed correctly as already cached', {
  # Create temporary project
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Set temporary project as working directory
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Clear the global environment
  clear()

  # Create some test data so the file can be loaded if not ignored
  test_data <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))

  # Build two temporary filenames
  test_file1 <- temp_csv_file()
  test_file2 <- temp_csv_file(dir = 'test')

  # Write test data to files
  write.csv(test_data, file = file.path('data', test_file1), row.names = FALSE)
  dir.create('data/test')
  write.csv(test_data, file = file.path('data', test_file2), row.names = FALSE)

  expect_error(data.files <- list.data(), NA)

  # Check if data.frame has three rows with default config:
  #   - fileXXXXX.csv (test_file1, not cached)
  #   - README.md (not ignored, not cached)
  #   - test (subdirectory, not cached)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', 'test'),
    varname = c(gsub('.csv', '', test_file1), '', ''),
    reader = c("csv.reader", "", ""),
    is_ignored = c(FALSE, FALSE, FALSE),
    is_directory = c(FALSE, FALSE, TRUE),
    is_cached = c(FALSE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$is_cached, test.df$is_cached)

  # Load the project so variables are cached, then list data again
  suppressMessages(load.project())
  expect_error(data.files <- list.data(), NA)

  # Check if data.frame has three rows with default config:
  #   - fileXXXXX.csv (test_file1, cached)
  #   - README.md (not ignored, not cached)
  #   - test (subdirectory, not cached)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', 'test'),
    varname = c(gsub('.csv', '', test_file1), '', ''),
    reader = c("csv.reader", "", ""),
    is_ignored = c(FALSE, FALSE, FALSE),
    is_directory = c(FALSE, FALSE, TRUE),
    is_cached = c(TRUE, FALSE, FALSE),
    cache_only = c(FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$is_cached, test.df$is_cached)
})

test_that('cached data created during munging listed as cached only', {
  # Create temporary project
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Set temporary project as working directory
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  # Clear the global environment
  clear()

  # Create some test data so the file can be loaded if not ignored
  test_data <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))

  # Build two temporary filenames
  test_file1 <- temp_csv_file()
  test_file2 <- temp_csv_file(dir = 'test')

  # Write test data to files
  write.csv(test_data, file = file.path('data', test_file1), row.names = FALSE)
  dir.create('data/test')
  write.csv(test_data, file = file.path('data', test_file2), row.names = FALSE)

  # Cache a code fragment
  cache(variable = "test_data", CODE = {
    data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))
  })

  expect_error(data.files <- list.data(), NA)

  # Check if data.frame has four rows with default config:
  #   - fileXXXXX.csv (test_file1, not cached)
  #   - README.md (not ignored, not cached)
  #   - test (subdirectory, not cached)
  #   - test_data (cached variable only)
  test.df <- data.frame(
    filename = c(test_file1, 'README.md', 'test', ''),
    varname = c(gsub('.csv', '', test_file1), '', '', 'test_data'),
    reader = c("csv.reader", "", "", ""),
    is_ignored = c(FALSE, FALSE, FALSE, FALSE),
    is_directory = c(FALSE, FALSE, TRUE, FALSE),
    is_cached = c(FALSE, FALSE, FALSE, TRUE),
    cache_only = c(FALSE, FALSE, FALSE, TRUE),
    stringsAsFactors = FALSE
  )
  # Sort data.frame according to collation of the testing process (for example
  # LC_COLLATE=C and LC_COLLATE=en_US.UTF-8 return different order)
  sort.df <- order(test.df$cache_only, test.df$filename, test.df$varname)
  test.df <- test.df[sort.df,]

  expect_equal(data.files$filename, test.df$filename)
  expect_equal(data.files$varname, test.df$varname)
  expect_equal(data.files$is_cached, test.df$is_cached)
  expect_equal(data.files$cache_only, test.df$cache_only)
})
