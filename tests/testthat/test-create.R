context('Create project')

expect_file <- function(..., condition = is_true()) {
  x <- file.path(...)
  expect_that(file.exists(x), condition, x)
}

expect_no_file <- function(...) expect_file(..., condition = is_false())

expect_dir <- function(...) {
  x <- file.path(...)
  expect_file(x)
  expect_true(.is.dir(x))
  expect_file(file.path(x, 'README.md'))
}

test_that('Full project', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

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

  suppressMessages(load.project())
  suppressMessages(test.project())

})

test_that('Miminal project', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = TRUE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

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

  suppressMessages(load.project())

})
