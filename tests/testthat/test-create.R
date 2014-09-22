context('Create project')

test_that('Full project', {
  suppressMessages(create.project('test_project', minimal = FALSE))

  expect_that(file.exists(file.path('test_project')), is_true())
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

test_that('Miminal project', {

  suppressMessages(create.project('test_project', minimal = TRUE))

  expect_that(file.exists(file.path('test_project')), is_true())
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
