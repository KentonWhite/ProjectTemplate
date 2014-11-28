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

expect_full <- function() {
  expect_dir('.')
  expect_dir('input', 'cache')
  expect_dir('code')
  expect_dir('config')
  expect_file('config', 'global.dcf')
  expect_dir('input')
  expect_dir('input', 'data')
  expect_dir('code', 'diagnostics')
  expect_file('code', 'diagnostics', '1.R')
  expect_dir('code', 'doc')
  expect_dir('results', 'graphs')
  expect_dir('code', 'lib')
  expect_file('code', 'lib', 'helpers.R')
  expect_dir('results', 'logs')
  expect_dir('code', 'munge')
  expect_file('code', 'munge', '01-A.R')
  expect_dir('code', 'profiling')
  expect_file('code', 'profiling', '1.R')
  expect_dir('results', 'reports')
  expect_dir('results')
  expect_dir('code', 'src')
  expect_file('code', 'src', 'eda.R')
  expect_dir('code', 'tests')
  expect_file('code', 'tests', '1.R')
  expect_file('TODO')
}

expect_minimal <- function() {
  expect_dir('.')
  expect_dir('input', 'cache')
  expect_dir('code')
  expect_dir('config')
  expect_file('config', 'global.dcf')
  expect_dir('input')
  expect_dir('input', 'data')
  expect_dir('code', 'munge')
  expect_file('code', 'munge', '01-A.R')
  expect_dir('code', 'src')
  expect_file('code', 'src', 'eda.R')

  expect_no_file('code', 'diagnostics')
  expect_no_file('doc')
  expect_no_file('graphs')
  expect_no_file('code', 'lib')
  expect_no_file('logs')
  expect_no_file('code', 'profiling')
  expect_no_file('reports')
  expect_no_file('code', 'tests')
  expect_no_file('TODO')
}

test_that('Full project', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  expect_full()

  suppressMessages(load.project())
  suppressMessages(test.project())

})

test_that('Miminal project', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = TRUE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  expect_minimal()

  suppressMessages(load.project())

})

test_that('Test full project into existing directory', {

  test_project <- tempfile('test_project')
  expect_that(file.exists(file.path(test_project)), is_false())
  dir.create(test_project)
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  expect_that(file.exists(file.path(test_project)), is_true())

  suppressMessages(create.project(test_project, minimal = FALSE))

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  expect_full()

  suppressMessages(load.project())
  suppressMessages(test.project())

})

test_that('Test minimal project into existing directory with an unrelated entry', {

  test_project <- tempfile('test_project')
  expect_that(file.exists(file.path(test_project)), is_false())
  dir.create(test_project)
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  expect_that(file.exists(file.path(test_project)), is_true())

  suppressMessages(create.project(test_project, minimal = TRUE, merge.strategy = "allow.non.conflict"))

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  expect_minimal()

  suppressMessages(load.project())

})

test_that('Test failure creating project into existing directory with an unrelated entry if merge.existing is not set', {

  test_project <- tempfile('test_project')
  expect_that(file.exists(file.path(test_project)), is_false())
  dir.create(test_project)
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  expect_that(file.exists(file.path(test_project)), is_true())

  file.create(file.path(test_project, '.dummy'))
  expect_that(file.exists(file.path(test_project, '.dummy')), is_true())
  dir.create(file.path(test_project, 'dummy_dir'))
  expect_that(file.exists(file.path(test_project, 'dummy_dir')), is_true())

  expect_error(
    suppressMessages(
      create.project(test_project, minimal = TRUE), "not empty"))

})

test_that('Test failure creating project in directory with existing empty directory matching the name of a template directory', {

  test_project <- tempfile('test_project')
  expect_that(file.exists(file.path(test_project)), is_false())
  dir.create(test_project)
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  expect_that(file.exists(file.path(test_project)), is_true())

  dir.create(file.path(test_project, 'munge'))
  expect_that(file.exists(file.path(test_project, 'munge')), is_true())

  expect_error(
    suppressMessages(
      create.project(test_project, minimal = TRUE,
                     merge.strategy = "allow.non.conflict"), "overwrite"))

})

test_that('Test failure creating project in directory with existing file matching the name of a template directory',{

  test_project <- tempfile('test_project')
  expect_that(file.exists(file.path(test_project)), is_false())
  dir.create(test_project)
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  expect_that(file.exists(file.path(test_project)), is_true())

  file.create(file.path(test_project, 'munge'))
  expect_that(file.exists(file.path(test_project, 'munge')), is_true())

  expect_error(
    suppressMessages(
      create.project(test_project, minimal = TRUE,
                     merge.strategy = "allow.non.conflict"), "overwrite"))

})

test_that('Test failure creating project in directory with existing empty directory matching the name of a template file', {

  test_project <- tempfile('test_project')
  expect_that(file.exists(file.path(test_project)), is_false())
  dir.create(test_project)
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  expect_that(file.exists(file.path(test_project)), is_true())

  dir.create(file.path(test_project, 'README.md'))
  expect_that(file.exists(file.path(test_project, 'README.md')), is_true())

  expect_error(
    suppressMessages(
      create.project(test_project, minimal = TRUE,
                     merge.strategy = "allow.non.conflict"), "overwrite"))


})

test_that('Test failure creating project in directory with existing file matching the name of a template file', {

  test_project <- tempfile('test_project')
  expect_that(file.exists(file.path(test_project)), is_false())
  dir.create(test_project)
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  expect_that(file.exists(file.path(test_project)), is_true())

  file.create(file.path(test_project, 'README.md'))
  expect_that(file.exists(file.path(test_project, 'README.md')), is_true())

  expect_error(
    suppressMessages(
      create.project(test_project, minimal = TRUE,
                     merge.strategy = "allow.non.conflict"), "overwrite"))

})
