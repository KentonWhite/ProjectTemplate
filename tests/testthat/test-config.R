context('Configuration')

test_that('Unknown fields give a warning, except if start with hash', {
  create.project('test_project', minimal = TRUE)
  setwd('test_project')
  on.exit(setwd('..'), add = TRUE)
  on.exit(unlink('test_project', recursive = TRUE), add = TRUE)

  config <- new.config
  config$dummy <- 'dummy'
  write.dcf(config, 'config/global.dcf')
  expect_that(load.project(), gives_warning("Your configuration contains the following unused entries"))

  config <- new.config
  write.dcf(config, 'config/global.dcf')
  # write.dcf won't allow writing fields that start with a hash
  config.dcf <- readLines('config/global.dcf')
  config.dcf <- c(config.dcf, "# comment: A comment",
                  "#: Yet another comment")
  writeLines(config.dcf, 'config/global.dcf')
  expect_that(load.project(), not(gives_warning()))
})
