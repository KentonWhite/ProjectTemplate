context('Readers')

test_that('Test 1: CSV Data file', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_01.csv'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_01.csv')
  variable.name <- clean.variable.name('example_01')

  csv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.01, envir = .TargetEnv)
})


test_that('Test 2: .csv.bz2', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_02.csv.bz2'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_02.csv.bz2')
  variable.name <- clean.variable.name('example_02')

  csv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.02, envir = .TargetEnv)

})


test_that('Test 3: csv.zip data', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_03.csv.zip'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_03.csv.zip')
  variable.name <- clean.variable.name('example_03')

  csv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.03, envir = .TargetEnv)

})


test_that('Example 04: CSV Data File with GZip Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_04.csv.gz'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_04.csv.gz')
  variable.name <- clean.variable.name('example_04')

  csv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.04, envir = .TargetEnv)

})


test_that('Example 05: TSV Data File', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_05.tsv'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_05.tsv')
  variable.name <- clean.variable.name('example_05')

  tsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.05, envir = .TargetEnv)

})


test_that('Example 06: TSV Data File with BZip2 Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_06.tsv.bz2'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_06.tsv.bz2')
  variable.name <- clean.variable.name('example_06')

  tsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.06, envir = .TargetEnv)

})


test_that('Example 07: TSV Data File with Zip Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_07.tsv.zip'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_07.tsv.zip')
  variable.name <- clean.variable.name('example_07')

  tsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.07, envir = .TargetEnv)

})


test_that('Example 08: TSV Data File with GZip Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_08.tsv.gz'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_08.tsv.gz')
  variable.name <- clean.variable.name('example_08')

  tsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.08, envir = .TargetEnv)

})

test_that('Example 09: WSV Data File', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_09.wsv'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_09.wsv')
  variable.name <- clean.variable.name('example_09')

  wsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  expect_false(any(is.na(as.matrix(get(variable.name)))))
  rm(example.09, envir = .TargetEnv)

})


test_that('Example 10: WSV Data File with BZip2 Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_10.wsv.bz2'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_10.wsv.bz2')
  variable.name <- clean.variable.name('example_10')

  wsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.10, envir = .TargetEnv)

})


test_that('Example 11: WSV Data File with Zip Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_11.wsv.zip'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_11.wsv.zip')
  variable.name <- clean.variable.name('example_11')

  wsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.11, envir = .TargetEnv)
})


test_that('Example 12: WSV Data File with GZip Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_12.wsv.gz'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_12.wsv.gz')
  variable.name <- clean.variable.name('example_12')

  wsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.12, envir = .TargetEnv)

})


test_that('Example 13: RData Data File with .RData Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_13.RData'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_13.RData')
  variable.name <- clean.variable.name('example_13')

  rdata.reader(data.file, filename, variable.name)

  expect_that(exists('m'), is_true())
  expect_that(names(get('m')), equals(c('N', 'Prime')))
  expect_that(nrow(get('m')), equals(5))
  expect_that(ncol(get('m')), equals(2))
  expect_that(get('m')[5, 2], equals(11))
  rm('m', envir = .TargetEnv)

})


test_that('Example 14: RData Data File with .rda Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_14.rda'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_14.rda')
  variable.name <- clean.variable.name('example_14')

  rdata.reader(data.file, filename, variable.name)

  expect_that(exists('n'), is_true())
  expect_that(names(get('n')), equals(c('N', 'Prime')))
  expect_that(nrow(get('n')), equals(5))
  expect_that(ncol(get('n')), equals(2))
  expect_that(get('n')[5, 2], equals(11))
  rm('n', envir = .TargetEnv)

})


test_that('Example 15: URL File with .url Extension', {

})


test_that('Example 16: TSV File with .tab Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_16.tab'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_16.tab')
  variable.name <- clean.variable.name('example_16')

  tsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.16, envir = .TargetEnv)
})


test_that('Example 17: TSV File with .tab Extension and BZip2 Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_17.tab.bz2'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_17.tab.bz2')
  variable.name <- clean.variable.name('example_17')

  tsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.17, envir = .TargetEnv)
})


test_that('Example 18: TSV File with .tab Extension and Zip Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_18.tab.zip'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_18.tab.zip')
  variable.name <- clean.variable.name('example_18')

  tsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.18, envir = .TargetEnv)
})


test_that('Example 19: TSV File with .tab Extension and GZip Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_19.tab.gz'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_19.tab.gz')
  variable.name <- clean.variable.name('example_19')

  tsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.19, envir = .TargetEnv)

})


test_that('Example 20: WSV File with .txt Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_20.txt'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_20.txt')
  variable.name <- clean.variable.name('example_20')

  wsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.20, envir = .TargetEnv)

})


test_that('Example 21: WSV File with .txt Extension and BZip2 Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_21.txt.bz2'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_21.txt.bz2')
  variable.name <- clean.variable.name('example_21')

  wsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.21, envir = .TargetEnv)

})


test_that('Example 22: WSV File with .txt Extension and Zip Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_22.txt.zip'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_22.txt.zip')
  variable.name <- clean.variable.name('example_22')

  wsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.22, envir = .TargetEnv)

})


test_that('Example 23: WSV File with .txt Extension and GZip Compression', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_23.txt.gz'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_23.txt.gz')
  variable.name <- clean.variable.name('example_23')

  wsv.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.23, envir = .TargetEnv)

})


test_that('Example 24: R File with .R Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_24.R'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_24.R')
  variable.name <- clean.variable.name('example_24')

  r.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.24, envir = .TargetEnv)

})


test_that('Example 25: R File with .r Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_25.r'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_25.r')
  variable.name <- clean.variable.name('example_25')

  r.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.25, envir = .TargetEnv)

})


test_that('Example 26: Excel 2007 File with .xls Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_26.xls'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_26.xls')
  variable.name <- clean.variable.name('example_26')

  xls.reader(data.file, filename, variable.name)

  variable.name <- paste(variable.name, '.Sheet1', sep = '')

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.26.Sheet1, envir = .TargetEnv)

})


test_that('Example 27: Excel 2011 File with .xlsx Extension', {

  #data.file <- 'example_27.xlsx'
  #filename <- file.path(system.file('example_data',
  #                                  package = 'ProjectTemplate'),
  #                      'example_27.xlsx')
  #variable.name <- clean.variable.name('example_27')
  #
  #xlsx.reader(data.file, filename, variable.name)
  #
  #variable.name <- paste(variable.name, '.Sheet1', sep = '')
  #
  #expect_that(exists(variable.name), is_true())
  #expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  #expect_that(nrow(get(variable.name)), equals(5))
  #expect_that(ncol(get(variable.name)), equals(2))
  #expect_that(get(variable.name)[5, 2], equals(11))
  #rm(example.27.Sheet1, envir = .TargetEnv)

})


test_that('Example 28: SQLite3 Support with .sql Extension with table = "..."', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  sql.file <- data.frame(type = 'sqlite',
                         dbname = file.path(system.file('example_data',
                                                        package = 'ProjectTemplate'),
                                            'example_28.db'),
                         table = 'example_28')
  write.dcf(sql.file, file = 'example_28.sql', width = 1000)

  data.file <- 'example_28.sql'
  filename <- 'example_28.sql'
  variable.name <- clean.variable.name('example_28')

  sql.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.28, envir = .TargetEnv)
  unlink('example_28.sql')

})


test_that('Example 29: SQLite3 Support with .sql Extension with query = "SELECT * FROM ..."', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  sql.file <- data.frame(type = 'sqlite',
                         dbname = file.path(system.file('example_data',
                                                        package = 'ProjectTemplate'),
                                            'example_29.db'),
                         query = 'SELECT * FROM example_29')
  write.dcf(sql.file, file = 'example_29.sql', width = 1000)

  data.file <- 'example_29.sql'
  filename <- 'example_29.sql'
  variable.name <- clean.variable.name('example_29')

  sql.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.29, envir = .TargetEnv)
  unlink('example_29.sql')

})


test_that('Example 30: SQLite3 Support with .sql Extension and table = "*"', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  sql.file <- data.frame(type = 'sqlite',
                         dbname = file.path(system.file('example_data',
                                                        package = 'ProjectTemplate'),
                                            'example_30.db'),
                         table = '*')
  write.dcf(sql.file, file = 'example_30.sql', width = 1000)

  data.file <- 'example_30.sql'
  filename <- 'example_30.sql'
  variable.name <- clean.variable.name('example_30')

  sql.reader(data.file, filename, variable.name)

  variable1.name <- clean.variable.name('example_30a')
  variable2.name <- clean.variable.name('example_30b')
  expect_that(exists(variable1.name), is_true())
  expect_that(names(get(variable1.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable1.name)), equals(5))
  expect_that(ncol(get(variable1.name)), equals(2))
  expect_that(get(variable1.name)[5, 2], equals(11))
  rm(example.30a, envir = .TargetEnv)
  expect_that(exists(variable2.name), is_true())
  expect_that(names(get(variable2.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable2.name)), equals(5))
  expect_that(ncol(get(variable2.name)), equals(2))
  expect_that(get(variable2.name)[5, 2], equals(11))
  rm(example.30b, envir = .TargetEnv)
  rm(example.30, envir = .TargetEnv)
  unlink('example_30.sql')

})


test_that('Example 31: SQLite3 Support with .db Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_31.db'
  filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                        'example_31.db')
  variable.name <- clean.variable.name('example_31')

  db.reader(data.file, filename, variable.name)

  variable1.name <- clean.variable.name('example_31a')
  variable2.name <- clean.variable.name('example_31b')
  expect_that(exists(variable1.name), is_true())
  expect_that(names(get(variable1.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable1.name)), equals(5))
  expect_that(ncol(get(variable1.name)), equals(2))
  expect_that(get(variable1.name)[5, 2], equals(11))
  rm(example.31a, envir = .TargetEnv)
  expect_that(exists(variable2.name), is_true())
  expect_that(names(get(variable2.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable2.name)), equals(5))
  expect_that(ncol(get(variable2.name)), equals(2))
  expect_that(get(variable2.name)[5, 2], equals(11))
  rm(example.31b, envir = .TargetEnv)
})


test_that('Example 32: Weka Support with .arff Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_32.arff'
  filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                        'example_32.arff')
  variable.name <- clean.variable.name('example_32')

  arff.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.32, envir = .TargetEnv)

})


test_that('Example 33: Arbitary File Support with .file File Pointing to .db File', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  info.file <- data.frame(path = file.path(system.file('example_data',
                                                        package = 'ProjectTemplate'),
                                            'example_28.db'),
                         extension = 'db')
  write.dcf(info.file, file = 'example_33.file', width = 1000)

  data.file <- 'example_33.file'
  filename <- 'example_33.file'
  variable.name <- clean.variable.name('example_28')

  file.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.28, envir = .TargetEnv)
  unlink('example_33.file')

})


test_that('Example 34: MP3 Support with .mp3 Extension', {

})


test_that('Example 35: PPM Support with .ppm Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_35.ppm'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_35.ppm')
  variable.name <- clean.variable.name('example_35')

  expect_warning(
    ppm.reader(data.file, filename, variable.name),
    " is NULL so the result will be NULL")

  expect_that(exists(variable.name), is_true())
  expect_that(as.character(class(get(variable.name))), equals('pixmapRGB'))
  rm(example.35, envir = .TargetEnv)

})


test_that('Example 36: dBase Support with .dbf Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_36.dbf'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_36.dbf')
  variable.name <- clean.variable.name('example_36')

  dbf.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.36, envir = .TargetEnv)

})


test_that('Example 37: SPSS Support with .sav Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_37.sav'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_37.sav')
  variable.name <- clean.variable.name('example_37')

  expect_warning(
    spss.reader(data.file, filename, variable.name),
    "Unrecognized record type 7, subtype 18 encountered in system file")

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.37, envir = .TargetEnv)

})


test_that('Example 38: SPSS Support with .sav Extension / Alternative Generation', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_38.sav'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_38.sav')
  variable.name <- clean.variable.name('example_38')

  expect_warning(
    spss.reader(data.file, filename, variable.name),
    "Unrecognized record type 7, subtype 18 encountered in system file")

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.38, envir = .TargetEnv)

})


test_that('Example 39: Stata Support with .dta Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_39.dta'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_39.dta')
  variable.name <- clean.variable.name('example_39')

  stata.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.39, envir = .TargetEnv)

})


test_that('Example 40: Stata Support with .dta Extension / Alternative Generation', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_40.dta'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_40.dta')
  variable.name <- clean.variable.name('example_40')

  stata.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.40, envir = .TargetEnv)

})


test_that('Example 41: SAS Support with .xport Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_41.xport'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_41.xport')
  variable.name <- clean.variable.name('example_41')

  xport.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'PRIME')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.41, envir = .TargetEnv)

})


test_that('Example 42: SAS Support with .xpt Extension', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  suppressMessages(load.project())

  data.file <- 'example_42.xpt'
  filename <- file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example_42.xpt')
  variable.name <- clean.variable.name('example_42')

  xport.reader(data.file, filename, variable.name)

  expect_that(exists(variable.name), is_true())
  expect_that(names(get(variable.name)), equals(c('N', 'PRIME')))
  expect_that(nrow(get(variable.name)), equals(5))
  expect_that(ncol(get(variable.name)), equals(2))
  expect_that(get(variable.name)[5, 2], equals(11))
  rm(example.42, envir = .TargetEnv)

})


test_that('Example 43: ElasticSearch Support with .es Extension', {

})
