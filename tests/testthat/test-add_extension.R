context('AddExtension')

test_that('Test 1: Add an extension', {
  foo1.reader <- function() {}

  .add.extension('foo1', 'foo1.reader')
  on.exit(rm(foo1.reader), add = TRUE)
  expect_that(extensions.dispatch.table[['\\.foo1$']], equals('foo1.reader'))

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  file.copy(file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'foo.reader.R'), file.path('lib', 'foo.reader.R'))
  file.copy(file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example.foo'), file.path('data', 'example.foo'))

  expect_that(file.exists(file.path('lib', 'foo.reader.R')), is_true())
  expect_that(file.exists(file.path('data', 'example.foo')), is_true())

  load.project()
  expect_that(extensions.dispatch.table[['\\.foo$']], equals('foo.reader'))
  expect_that(get('example',envir = .GlobalEnv), equals("bar"))


})
