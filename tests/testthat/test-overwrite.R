context('With existing project')

test_that('Test full project into existing directory', {

  test_project <- tempfile('test_project')
  expect_that(file.exists(file.path(test_project)), is_false())
  dir.create(test_project)
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  expect_that(file.exists(file.path(test_project)), is_true())

  suppressMessages(create.project(test_project, minimal = FALSE))

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  expect_that(file.exists(file.path('cache')), is_true())
  expect_that(file.exists(file.path('config')), is_true())
  expect_that(file.exists(file.path('config', 'global.dcf')), is_true())
  expect_that(file.exists(file.path('data')), is_true())
  expect_that(file.exists(file.path('diagnostics')), is_true())
  expect_that(file.exists(file.path('doc')), is_true())
  expect_that(file.exists(file.path('graphs')), is_true())
  expect_that(file.exists(file.path('lib')), is_true())
  expect_that(file.exists(file.path('lib', 'helpers.R')), is_true())
  expect_that(file.exists(file.path('logs')), is_true())
  expect_that(file.exists(file.path('munge')), is_true())
  expect_that(file.exists(file.path('munge', '01-A.R')), is_true())
  expect_that(file.exists(file.path('profiling')), is_true())
  expect_that(file.exists(file.path('profiling', '1.R')), is_true())
  expect_that(file.exists(file.path('reports')), is_true())
  expect_that(file.exists(file.path('src')), is_true())
  expect_that(file.exists(file.path('tests')), is_true())
  expect_that(file.exists(file.path('tests', '1.R')), is_true())
  expect_that(file.exists(file.path('README.md')), is_true())
  expect_that(file.exists(file.path('TODO')), is_true())

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

  expect_that(file.exists(file.path('cache')), is_true())
  expect_that(file.exists(file.path('config')), is_true())
  expect_that(file.exists(file.path('config', 'global.dcf')), is_true())
  expect_that(file.exists(file.path('data')), is_true())
  expect_that(file.exists(file.path('munge')), is_true())
  expect_that(file.exists(file.path('munge', '01-A.R')), is_true())
  expect_that(file.exists(file.path('src')), is_true())
  expect_that(file.exists(file.path('README.md')), is_true())

  suppressMessages(load.project())

  setwd('..')

  unlink('test_project', recursive = TRUE)
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
