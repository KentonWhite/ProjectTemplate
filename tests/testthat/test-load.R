context('Load project')

test_that('All elements have length 1', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  suppressMessages(load.project())
  expect_equal(unname(vapply(config, length, integer(1))), rep(1L, length(config)))
})
