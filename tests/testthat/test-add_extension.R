context('AddExtension')

test_that('Test 1: Add an extension', {
  foo1.reader <- function() {}
	
  .add.extension('foo1', 'foo1.reader')
  expect_that(ProjectTemplate:::extensions.dispatch.table[['\\.foo1$']], equals('foo1.reader'))

  create.project('test_project', minimal = FALSE)
  file.copy(file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'foo.reader.R'), file.path('test_project', 'lib', 'foo.reader.R'))
  file.copy(file.path(system.file('example_data',
                                    package = 'ProjectTemplate'),
                        'example.foo'), file.path('test_project', 'data', 'example.foo'))

  expect_that(file.exists(file.path('test_project', 'lib', 'foo.reader.R')), is_true())
  expect_that(file.exists(file.path('test_project', 'data', 'example.foo')), is_true())

  setwd('test_project')

  load.project()
  expect_that(ProjectTemplate:::extensions.dispatch.table[['\\.foo$']], equals('foo.reader'))
  expect_that(get('example',envir = .GlobalEnv), equals("bar"))
  setwd('..')

  unlink('test_project', recursive = TRUE)
  rm(foo1.reader)

})