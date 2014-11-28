context('Load project')

test_that('All elements have length 1', {
  suppressMessages(create.project('test_project', minimal = FALSE))
  setwd('test_project')

  on.exit(setwd('..'), add = TRUE)
  on.exit(unlink('test_project', recursive = TRUE), add = TRUE)

  suppressMessages(load.project())
  expect_equal(unname(vapply(config, length, integer(1))), rep(1L, length(config)))
})
