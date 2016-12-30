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

test_that('user commands fail when not in ProjectTemplate directory', {
        test_project <- tempfile('test_project')
        dir.create(test_project)
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # Check load.project()
        expect_error(load.project())

        # Check clear.cache()
        expect_error(clear.cache())

        # Check cache()
        expect_error(cache())
        
        # Check reload.project()
        expect_error(reload.project())
        
        # Check reload.project()
        expect_error(test.project())
        
        # Check stub.tests()
        expect_error(stub.tests())
        
        # Check project.config()
        expect_error(project.config())
        
})

test_that('auto loaded data is cached by default', {
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        
        test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
        
        # save test data as a csv in the data directory
        write.csv(test_data, file="data/test.csv", row.names = FALSE)
        
        suppressMessages(load.project())
        
        # check that the cached file loads without error
        expect_error(load("cache/test.RData", envir = environment()), NA)
        
        # and check that the loaded data from the cache is what we saved
        expect_equal(test, test_data)
})

test_that('auto loaded data is not cached when cached_loaded_data is FALSE', {
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        
        test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
        
        # save test data as a csv in the data directory
        write.csv(test_data, file="data/test.csv", row.names = FALSE)
        
        # Read the config data and set cache_loaded_data to FALSE
        config <- read.dcf("config/global.dcf")
        expect_error(config$cache_loaded_data <- FALSE, NA)
        write.dcf(config, "config/global.dcf" )
        
        suppressMessages(load.project())
        
        # check that the the test variable has not been cached
        expect_error(load("cache/test.RData", envir = environment()), "cannot open the connection")
        

})



test_that('auto loaded data from an R script is cached correctly', {
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # clear the global environment
        rm(list=ls(envir = .TargetEnv), envir = .TargetEnv)
        
        # create some variables in the global env that shouldn't be cached
        test_data11 <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
        test_data21 <- data.frame(Names=c("a1", "b1", "c1"), Ages=c(20,30,40))
        
        # Create some R code and put in data directory 
        CODE <- paste0(deparse(substitute({
                test_data12 <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
                test_data22 <- data.frame(Names=c("a1", "b1", "c1"), Ages=c(20,30,40))        
                
        })), collapse ="\n")
        
        # save R code in the data directory
        writeLines(CODE, "data/test.R")
        
        # load the project and R code
        suppressMessages(load.project())
        
        # check that the test variables have been cached correctly
        expect_error(load("cache/test_data12.RData", envir = environment()), NA)
        expect_error(load("cache/test_data22.RData", envir = environment()), NA)
        
        # check that the other test variables have not been cached 
        expect_error(load("cache/test_data11.RData", envir = environment()), 
                     "cannot open the connection")
        expect_error(load("cache/test_data21.RData", envir = environment()),
                     "cannot open the connection")
})


