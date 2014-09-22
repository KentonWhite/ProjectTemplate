context('With existing project')

test_that('Test full project into existing directory', {

  expect_that(file.exists(file.path('test_project')), is_false())
  dir.create('test_project')
  expect_that(file.exists(file.path('test_project')), is_true())

  suppressMessages(create.project('test_project', minimal = FALSE))

  expect_that(file.exists(file.path('test_project', 'cache')), is_true())
  expect_that(file.exists(file.path('test_project', 'config')), is_true())
  expect_that(file.exists(file.path('test_project', 'config', 'global.dcf')), is_true())
  expect_that(file.exists(file.path('test_project', 'data')), is_true())
  expect_that(file.exists(file.path('test_project', 'diagnostics')), is_true())
  expect_that(file.exists(file.path('test_project', 'doc')), is_true())
  expect_that(file.exists(file.path('test_project', 'graphs')), is_true())
  expect_that(file.exists(file.path('test_project', 'lib')), is_true())
  expect_that(file.exists(file.path('test_project', 'lib', 'helpers.R')), is_true())
  expect_that(file.exists(file.path('test_project', 'logs')), is_true())
  expect_that(file.exists(file.path('test_project', 'munge')), is_true())
  expect_that(file.exists(file.path('test_project', 'munge', '01-A.R')), is_true())
  expect_that(file.exists(file.path('test_project', 'profiling')), is_true())
  expect_that(file.exists(file.path('test_project', 'profiling', '1.R')), is_true())
  expect_that(file.exists(file.path('test_project', 'reports')), is_true())
  expect_that(file.exists(file.path('test_project', 'src')), is_true())
  expect_that(file.exists(file.path('test_project', 'tests')), is_true())
  expect_that(file.exists(file.path('test_project', 'tests', '1.R')), is_true())
  expect_that(file.exists(file.path('test_project', 'README')), is_true())
  expect_that(file.exists(file.path('test_project', 'TODO')), is_true())

  setwd('test_project')

  suppressMessages(load.project())
  suppressMessages(test.project())

  setwd('..')

  unlink('test_project', recursive = TRUE)

})

test_that('Test minimal project into existing directory with an unrelated entry', {

  expect_that(file.exists(file.path('test_project')), is_false())
  dir.create('test_project')
  expect_that(file.exists(file.path('test_project')), is_true())
  file.create(file.path('test_project', '.dummy'))
  expect_that(file.exists(file.path('test_project', '.dummy')), is_true())
  dir.create(file.path('test_project', 'dummy_dir'))
  expect_that(file.exists(file.path('test_project', 'dummy_dir')), is_true())

  suppressMessages(create.project('test_project', minimal = TRUE, merge.strategy = "allow.non.conflict"))

  expect_that(file.exists(file.path('test_project', 'cache')), is_true())
  expect_that(file.exists(file.path('test_project', 'config')), is_true())
  expect_that(file.exists(file.path('test_project', 'config', 'global.dcf')), is_true())
  expect_that(file.exists(file.path('test_project', 'data')), is_true())
  expect_that(file.exists(file.path('test_project', 'munge')), is_true())
  expect_that(file.exists(file.path('test_project', 'munge', '01-A.R')), is_true())
  expect_that(file.exists(file.path('test_project', 'src')), is_true())
  expect_that(file.exists(file.path('test_project', 'README')), is_true())

  setwd('test_project')

  suppressMessages(load.project())

  setwd('..')

  unlink('test_project', recursive = TRUE)
})

test_that('Test failure creating project into existing directory with an unrelated entry if merge.existing is not set', {

  expect_that(file.exists(file.path('test_project')), is_false())
  dir.create('test_project')
  expect_that(file.exists(file.path('test_project')), is_true())
  file.create(file.path('test_project', '.dummy'))
  expect_that(file.exists(file.path('test_project', '.dummy')), is_true())
  dir.create(file.path('test_project', 'dummy_dir'))
  expect_that(file.exists(file.path('test_project', 'dummy_dir')), is_true())

  expect_error(
    suppressMessages(
      create.project('test_project', minimal = TRUE), "not empty"))

  unlink('test_project', recursive = TRUE)
})

test_that('Test failure creating project in directory with existing empty directory matching the name of a template directory', {

  expect_that(file.exists(file.path('test_project')), is_false())
  dir.create('test_project')
  expect_that(file.exists(file.path('test_project')), is_true())
  dir.create(file.path('test_project', 'munge'))
  expect_that(file.exists(file.path('test_project', 'munge')), is_true())

  expect_error(
    suppressMessages(
      create.project('test_project', minimal = TRUE,
                     merge.strategy = "allow.non.conflict"), "overwrite"))

  unlink('test_project', recursive = TRUE)

})

test_that('Test failure creating project in directory with existing file matching the name of a template directory',{

  expect_that(file.exists(file.path('test_project')), is_false())
  dir.create('test_project')
  expect_that(file.exists(file.path('test_project')), is_true())
  file.create(file.path('test_project', 'munge'))
  expect_that(file.exists(file.path('test_project', 'munge')), is_true())

  expect_error(
    suppressMessages(
      create.project('test_project', minimal = TRUE,
                     merge.strategy = "allow.non.conflict"), "overwrite"))

  unlink('test_project', recursive = TRUE)

})

test_that('Test failure creating project in directory with existing empty directory matching the name of a template file', {

  expect_that(file.exists(file.path('test_project')), is_false())
  dir.create('test_project')
  expect_that(file.exists(file.path('test_project')), is_true())
  dir.create(file.path('test_project', 'README'))
  expect_that(file.exists(file.path('test_project', 'README')), is_true())

  expect_error(
    suppressMessages(
      create.project('test_project', minimal = TRUE,
                     merge.strategy = "allow.non.conflict"), "overwrite"))

  unlink('test_project', recursive = TRUE)

})

test_that('Test failure creating project in directory with existing file matching the name of a template file', {

  expect_that(file.exists(file.path('test_project')), is_false())
  dir.create('test_project')
  expect_that(file.exists(file.path('test_project')), is_true())
  file.create(file.path('test_project', 'README'))
  expect_that(file.exists(file.path('test_project', 'README')), is_true())

  expect_error(
    suppressMessages(
      create.project('test_project', minimal = TRUE,
                     merge.strategy = "allow.non.conflict"), "overwrite"))

  unlink('test_project', recursive = TRUE)

})
