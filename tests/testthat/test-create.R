context('Create project')

expect_file <- function(x, condition = is_true()) {
  expect_that(file.exists(file.path('test_project', x)), condition, x)
}

expect_no_file <- function(x) expect_file(x, is_false())

expect_dir <- function(x) {
  expect_file(x)
  expect_file(file.path(x, 'README.md'))
}

test_that('Full project', {
  suppressMessages(create.project('test_project', minimal = FALSE))

  expect_dir('.')
  expect_dir('cache')
  expect_dir('config')
  expect_file(file.path('config', 'global.dcf'))
  expect_dir('data')
  expect_dir('diagnostics')
  expect_file(file.path('diagnostics', '1.R'))
  expect_dir('doc')
  expect_dir('graphs')
  expect_dir('lib')
  expect_file(file.path('lib', 'helpers.R'))
  expect_dir('logs')
  expect_dir('munge')
  expect_file(file.path('munge', '01-A.R'))
  expect_dir('profiling')
  expect_file(file.path('profiling', '1.R'))
  expect_dir('reports')
  expect_dir('src')
  expect_file(file.path('src', 'eda.R'))
  expect_dir('tests')
  expect_file(file.path('tests', '1.R'))
  expect_file(file.path('TODO'))

  setwd('test_project')

  suppressMessages(load.project())
  suppressMessages(test.project())

  setwd('..')

  unlink('test_project', recursive = TRUE)

})

test_that('Miminal project', {

  suppressMessages(create.project('test_project', minimal = TRUE))

  expect_dir('.')
  expect_dir('cache')
  expect_dir('config')
  expect_file(file.path('config', 'global.dcf'))
  expect_dir('data')
  expect_dir('munge')
  expect_file(file.path('munge', '01-A.R'))
  expect_dir('src')
  expect_file(file.path('src', 'eda.R'))

  expect_no_file('diagnostics')
  expect_no_file('doc')
  expect_no_file('graphs')
  expect_no_file('lib')
  expect_no_file('logs')
  expect_no_file('profiling')
  expect_no_file('reports')
  expect_no_file('tests')
  expect_no_file('TODO')

  setwd('test_project')

  suppressMessages(load.project())

  setwd('..')

  unlink('test_project', recursive = TRUE)

})
