context('Override configuration')

test_that('Overridden configuration is stored in config', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  expect_warning(load.project(new_config_setting = TRUE), NA)
  expect_equal(config$.override.config, list(new_config_setting = TRUE))
})

test_that('Old-style named argument override.config to load.project is parsed correctly', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  override.config <- list(new_config_setting = TRUE)
  expect_warning(load.project(override.config = override.config), NA)
  expect_equal(config$.override.config, override.config)

  override.config <- list(new_config_setting = TRUE, second_custom_config = 'a')
  expect_warning(load.project(override.config = override.config), NA)
  expect_equal(config$.override.config, override.config)
})

test_that('Old-style unnamed argument override.config to load.project is parsed correctly', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  override.config <- list(new_config_setting = TRUE)
  expect_warning(load.project(override.config), NA)
  expect_equal(config$.override.config, override.config)

  override.config <- list(new_config_setting = TRUE, second_custom_config = 'a')
  expect_warning(load.project(override.config), NA)
  expect_equal(config$.override.config, override.config)
})

test_that('New-style ... argument to load.project is parsed correctly', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  expect_warning(load.project(new_config_setting = TRUE), NA)
  expect_equal(config$.override.config, list(new_config_setting = TRUE))

  expect_warning(load.project(new_config_setting = TRUE, second_custom_config = 'a'), NA)
  expect_equal(config$.override.config, list(new_config_setting = TRUE, second_custom_config = 'a'))
})

test_that('New-style ... argument to load.project is parsed correctly when passing a single list', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  expect_warning(load.project(new_config_setting = list(a = 1)), NA)
  expect_equal(config$.override.config, list(new_config_setting = list(a = 1)))
})

test_that('Override configuration to built in options is applied correctly', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  config <- .new.config
  config$load_libraries <- TRUE
  write.dcf(config, 'config/global.dcf')
  rm(config)

  expect_warning(load.project(load_libraries = FALSE), NA)
  expect_equal(config$.override.config, list(load_libraries = FALSE))
  expect_equal(config$load_libraries, FALSE)

  expect_warning(load.project(load_libraries = FALSE, munging = FALSE), NA)
  expect_equal(config$.override.config, list(load_libraries = FALSE, munging = FALSE))
  expect_equal(config$load_libraries, FALSE)
  expect_equal(config$munging, FALSE)
})

test_that('Override configuration to custom options is applied correctly', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  writeLines('add.config(new_option = TRUE, apply.override = TRUE)',
             file.path('lib', 'globals.R'))

  expect_warning(load.project(), NA)
  expect_equal(config$new_option, TRUE)

  expect_warning(load.project(new_option = FALSE), NA)
  expect_equal(config$.override.config, list(new_option = FALSE))
  expect_equal(config$new_option, FALSE)
})

test_that('Override configuration to built in and custom options is applied correctly', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  writeLines('add.config(new_option = TRUE, apply.override = TRUE)', file.path('lib', 'globals.R'))

  expect_warning(load.project(), NA)
  expect_equal(config$new_option, TRUE)

  expect_warning(load.project(munging = FALSE, new_option = FALSE), NA)
  expect_equal(config$.override.config, list(munging = FALSE, new_option = FALSE))
  expect_equal(config$munging, FALSE)
  expect_equal(config$new_option, FALSE)
})

test_that('Unnamed override (not being a list) raises an error', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  expect_warning(load.project(), NA)
  expect_error(load.project('a'), 'All options should be named')
})

test_that('Override configuration to custom options is not applied when using apply.override = FALSE', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  on.exit(clear(), add = TRUE)

  writeLines('add.config(new_option = TRUE, apply.override = FALSE)', file.path('lib', 'globals.R'))

  expect_warning(load.project(), NA)
  expect_equal(config$new_option, TRUE)

  expect_warning(load.project(new_option = FALSE), NA)
  expect_equal(config$.override.config, list(new_option = FALSE))
  expect_equal(config$new_option, TRUE)
})
