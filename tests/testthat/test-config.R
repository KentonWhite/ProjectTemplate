context('Configuration')

test_that('Unknown fields give a warning, except if start with hash', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = TRUE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  config <- .new.config
  config$dummy <- 'dummy'
  write.dcf(config, 'config/global.dcf')
  expect_that(load.project(), gives_warning("Your configuration contains the following unused entries"))

  config <- .new.config
  write.dcf(config, 'config/global.dcf')
  # write.dcf won't allow writing fields that start with a hash
  config.dcf <- readLines('config/global.dcf')
  config.dcf <- c(config.dcf, "# comment: A comment",
                  "#: Yet another comment")
  writeLines(config.dcf, 'config/global.dcf')
  expect_warning(load.project(), NA)

})

test_that('project.config() displays standard and additional config correctly', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = TRUE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # Read the config and flip a value
        config <- .read.config()
        flipped_value <- !config$as_factors
        config$as_factors <- flipped_value
        .save.config(config)
        
        # check that the flipped value is displayed
        expect_message(project.config(), paste0("as_factors[ ]+", as.character(flipped_value)))
        
        # create a new custom configuration
        add.config(dummy=999)
        
        # check that the Additional custom config is displayed
        expect_message(project.config(), "Additional custom config present")
        
        
        # check that the dummy value is displayed
        expect_message(project.config(), "dummy[ ]+999")
        
        
})
