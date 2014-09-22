context('Clean variable names')

test_that('Cleans variable names', {

  create.project('test_project')

  setwd('test_project')

  load.project()

  expect_that(ProjectTemplate:::clean.variable.name('test_me'), equals('test.me'))
  expect_that(ProjectTemplate:::clean.variable.name('test-me'), equals('test.me'))
  expect_that(ProjectTemplate:::clean.variable.name('test..me'), equals('test.me'))
  expect_that(ProjectTemplate:::clean.variable.name('test me'), equals('test.me'))
  expect_that(ProjectTemplate:::clean.variable.name('1990'), equals('X1990'))

  setwd('..')

  unlink('test_project', recursive = TRUE)
})

