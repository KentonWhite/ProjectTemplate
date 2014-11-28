context('AddExtension')

test_that('Test 1: Add an extension', {
  foo1.reader <- function() {}

  .add.extension('foo1', 'foo1.reader')
  on.exit(rm(foo1.reader), add = TRUE)
  expect_that(ProjectTemplate:::extensions.dispatch.table[['\\.foo1$']], equals('foo1.reader'))

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  file.copy(file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'foo.reader.R'), file.path(test_project, 'lib', 'foo.reader.R'))
  file.copy(file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example.foo'), file.path(test_project, 'data', 'example.foo'))

  expect_that(file.exists(file.path(test_project, 'lib', 'foo.reader.R')), is_true())
  expect_that(file.exists(file.path(test_project, 'data', 'example.foo')), is_true())

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  load.project()
  expect_that(ProjectTemplate:::extensions.dispatch.table[['\\.foo$']], equals('foo.reader'))
  expect_that(get('example',envir = .GlobalEnv), equals("bar"))


})
