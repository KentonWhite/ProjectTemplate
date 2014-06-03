context('Version field')

test_that('Test matching version field', {

  create.project('test_project', minimal = TRUE)
  setwd('test_project')
  on.exit(setwd('..'), add = TRUE)
  on.exit(unlink('test_project', recursive = TRUE), add = TRUE)

  expect_that(load.project(), not(gives_warning()))

})

test_that('Test too old version of ProjectTemplate', {

  create.project('test_project', minimal = TRUE)
  setwd('test_project')
  on.exit(setwd('..'), add = TRUE)
  on.exit(unlink('test_project', recursive = TRUE), add = TRUE)

  config <- default.config
  config$version <- paste0('1', config$version)
  write.dcf(config, 'config/global.dcf')

  expect_that(load.project(), throws_error("Please upgrade ProjectTemplate"))

})

test_that('Test new version of ProjectTemplate', {

  create.project('test_project', minimal = TRUE)
  setwd('test_project')
  on.exit(setwd('..'), add = TRUE)
  on.exit(unlink('test_project', recursive = TRUE), add = TRUE)

  config <- default.config
  config$version <- '0.4'
  write.dcf(config, 'config/global.dcf')

  expect_that(load.project(), gives_warning("ProjectTemplate::migrate()"))

})
