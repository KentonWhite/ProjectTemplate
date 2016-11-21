context('Clearing from memory')

tidy_up <- function () {
        objs <- setdiff(ls(envir = .TargetEnv), "tidy_up")
        rm(list = objs, envir = .TargetEnv)
}


test_that('running clear() with default parameters removes everything except config', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  
  suppressMessages(load.project())
  
  # default objects are config helper.function project.info
  # Because sticky_cvariables is not set, the config variable should be wiped also
  
  expect_message(clear(), "clear from memory: config helper.function project.info")
  
  # check they don't exist
  expect_true(!exists(c("project.info", "helper.function"), envir = .TargetEnv))

  # check config does not exist
  expect_true(!exists("config", envir = .TargetEnv))  

  tidy_up()
})


test_that('running clear(keep=helper.function) removes everything except the helper.function', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        suppressMessages(load.project())
        
        # default objects are config helper.function project.info
        expect_message(clear(keep="helper.function"), "not cleared: helper.function")
        
        # check the others don't exist
        expect_true(!exists("project.info", envir = .TargetEnv))
        
        # check that config also does not exist
        expect_true(!exists("config", envir = .TargetEnv))
        
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
        cfg$sticky_variables <- "helper.function"
        .save.config(cfg)
        
        suppressMessages(load.project())
        
        
        # default objects are config helper.function  project.info
        expect_message(clear(), "not cleared: config helper.function")
        
        # check the others don't exist
        expect_true(!exists("project.info", envir = .TargetEnv))
        
        # check that config and helper.function does exist
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
        config$sticky_variables <- "helper.function"
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

test_that('running in a project template directory loads the latest config.dcf', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # Read the config and set config$sticky_variables
        config <- .read.config()
        config$sticky_variables <- "xxx"
        .save.config(config)
        
        # set the sticky variable
        assign("xxx", 1, envir = .TargetEnv)
             
        # set another variable
        assign("yyy", 2, envir = .TargetEnv)
        
        # check xxx is not cleared
        expect_message(clear(), "not cleared: config xxx")
        
        # check xxx is still exists
        expect_true(exists("xxx", envir = .TargetEnv))
        
        # check the others don't exist
        expect_true(!exists("yyy", envir = .TargetEnv))
        
        # check that config  exists 
        expect_true(exists("config", envir = .TargetEnv))
        
        tidy_up()
})

test_that('running clear() with variables that dont exist fail cleanly', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # nothing in memory
        expect_message(clear("xxx"), "No objects to clear")
        
        # Read the config and set config$sticky_variables
        config <- .read.config()
        config$sticky_variables <- "xxx"
        .save.config(config)
        
        # should still be nothing, even though it's defined in config$sticky_variables
        expect_message(clear("xxx"), "No objects to clear")
        
        tidy_up()
})

test_that('running clear() with an object not in memory fails cleanly', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # Try to delete an item that doesn't exist
        
        expect_message(clear("yyyy"), "objects not in memory: yyyy")

        tidy_up()
})
