context('Clearing from memory')

tidy_up <- function () {
        objs <- setdiff(ls(envir = .TargetEnv), "tidy_up")
        rm(list = objs, envir = .TargetEnv)
}


test_that('running clear() with default parameters removes everything', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  
  suppressMessages(load.project())
  
  # default objects are config helper.function project.info
  expect_message(clear(), "clear from memory: config helper.function project.info")
  
  # check they don't exist
  expect_true(!exists(c("config", "project.info", "helper.function"), envir = .TargetEnv))
  
  tidy_up()
})


test_that('running clear(keep=config) removes everything except the config', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        suppressMessages(load.project())
        
        # default objects are config helper.function project.info
        expect_message(clear(keep="config"), "not cleared: config")
        
        # check the others don't exist
        expect_true(!exists(c( "project.info", "helper.function"), envir = .TargetEnv))
        
        # check that config does exist
        expect_true(exists("config", envir = .TargetEnv))
        
        tidy_up()
})

test_that('running clear() removes everything except the config$sticky_variables', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # Read the config and set config$sticky_variables
        cfg <- .read.config()
        cfg$sticky_variables <- "config, helper.function"
        .save.config(cfg)
        
        suppressMessages(load.project())
        
        
        # default objects are config helper.function  project.info
        expect_message(clear(), "not cleared: config helper.function")
        
        # check the others don't exist
        expect_true(!exists("project.info", envir = .TargetEnv))
        
        # check that config does exist
        expect_true(exists(c("config", "helper.function"), envir = .TargetEnv))
        
        tidy_up()
})

test_that('running clear(force=TRUE) removes everything including the config$sticky_variables', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # Read the config and set config$sticky_variables
        config <- .read.config()
        config$sticky_variables <- "config, helper.function"
        .save.config(config)
        
        suppressMessages(load.project())
        
        
        # default objects are config helper.function  project.info
        expect_message(clear(force=TRUE), "clear from memory: config helper.function project.info")
        
        # check they don't exist
        expect_true(!exists(c("project.info"), envir = .TargetEnv))
        expect_true(!exists(c("config"), envir = .TargetEnv))
        expect_true(!exists(c("helper.function"), envir = .TargetEnv))
        
        tidy_up()
})
