context('Version field')

test_that('Test matching version field', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = TRUE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  
  expect_warning(suppressMessages(load.project()), NA)

})

test_that('Test too old version of ProjectTemplate', {
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = TRUE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  
  config <- .new.config
  config$version <- paste0('1', config$version)
  write.dcf(config, 'config/global.dcf')

  expect_that(suppressMessages(load.project()), throws_error("Please upgrade ProjectTemplate"))

})

test_that('Test new version of ProjectTemplate', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = TRUE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  config <- .new.config
  config$version <- '0.4'
  write.dcf(config, 'config/global.dcf')

  expect_that(suppressMessages(load.project()),
              gives_warning("ProjectTemplate::migrate.project()"))

})

test_that('Test migration', {
        
  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = TRUE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
        
        
  config <- .new.config
  expect_true("version" %in% names(config))
  config$version <- '0.4'
  write.dcf(config, 'config/global.dcf')

  suppressMessages(migrate.project())
  expect_equal(sum(grepl("^version: ", readLines('config/global.dcf'))), 1)
  expect_warning(suppressMessages(load.project()), NA)

})
