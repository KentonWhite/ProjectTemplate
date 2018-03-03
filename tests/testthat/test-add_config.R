context('Add custom configuration')

test_that('Custom configuration is added to config', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  expect_warning(load.project(), NA)
  expect_error(add.config(new_config = 'a'), NA)
  expect_equal(config$new_config, 'a')
})

test_that('Unnamed added configuration raises an error', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  expect_warning(load.project(), NA)
  expect_error(add.config('a'), 'All options should be named')
})

test_that('Added configuration is displayed correctly by project.config()', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  expect_warning(load.project(), NA)
  expect_error(add.config(dummy = 999), NA)

  expect_message(project.config(), "Additional custom config present")
  expect_message(project.config(), "dummy[ ]+999")
})


