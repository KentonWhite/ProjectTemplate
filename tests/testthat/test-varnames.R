context('Clean variable names')

test_that('Cleans variable names', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  suppressMessages(load.project())

  expect_that(ProjectTemplate:::clean.variable.name('test_me'), equals('test.me'))
  expect_that(ProjectTemplate:::clean.variable.name('test-me'), equals('test.me'))
  expect_that(ProjectTemplate:::clean.variable.name('test..me'), equals('test.me'))
  expect_that(ProjectTemplate:::clean.variable.name('test me'), equals('test.me'))
  expect_that(ProjectTemplate:::clean.variable.name('1990'), equals('X1990'))

})
