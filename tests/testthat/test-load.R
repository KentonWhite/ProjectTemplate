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

test_that('Dont load when not in ProjectTemplate directory', {
        test_project <- tempfile('test_project')
        dir.create(test_project)
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        expect_message(load.project(), "is not a ProjectTemplate directory")
        
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
