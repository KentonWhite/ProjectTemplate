context('Reload project')

test_that('override.config is passed through correctly to load.project', {
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        clear(force=TRUE)
        
        # Create some R code and put in data directory 
        CODE <- paste0(deparse(substitute({
                x <- 10
                
        })), collapse ="\n")
        
        # save R code in the data directory
        writeLines(CODE, "data/x.R")
        
        CODE <- paste0(deparse(substitute({
                y <- 20
                
        })), collapse ="\n")
        
        # save R code in the data directory
        writeLines(CODE, "data/y.R")
        
        CODE <- paste0(deparse(substitute({
                z <- 10
                
        })), collapse ="\n")
        
        # save R code in the data directory
        writeLines(CODE, "data/z.R")
        
        # reload the project but switch off data loading
        suppressMessages(reload.project(override.config=list(data_loading=FALSE)))
        
        # x should not exist in Global Env or the cache
        expect_true(!exists("x"))
        expect_true(!.read.cache.info("x")$in.cache)
        
})

test_that('reload.project ignores sticky_variables', {
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        clear(force=TRUE)
        
        # Create some R code and put in data directory 
        CODE <- paste0(deparse(substitute({
                x <- 10
                
        })), collapse ="\n")
        
        # save R code in the data directory
        writeLines(CODE, "data/x.R")
        
        CODE <- paste0(deparse(substitute({
                y <- 20
                
        })), collapse ="\n")
        
        # save R code in the data directory
        writeLines(CODE, "data/y.R")
        
        CODE <- paste0(deparse(substitute({
                z <- 10
                
        })), collapse ="\n")
        
        # save R code in the data directory
        writeLines(CODE, "data/z.R")
        
        # Read the config data and set sticky_variables to x,y
        config <- translate.dcf("config/global.dcf")
        expect_error(config$sticky_variables <- "x,y", NA)
        write.dcf(config, "config/global.dcf" )
        
        # Load the project and check that x exists and is in the cache
        suppressMessages(load.project())
        expect_true(exists("x"))
        expect_true(.read.cache.info("x")$in.cache)
        
        # reload the project and config, x, y should not be cleared
        expect_message(reload.project(), "not cleared: config x y")
        
        # Also, z should be reloaded from data
        expect_true(exists("z"))
        
        
})

test_that('reload.project with reset clears everything', {
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        clear(force=TRUE)
        
        # Create some R code and put in data directory 
        CODE <- paste0(deparse(substitute({
                x <- 10
                
        })), collapse ="\n")
        
        # save R code in the data directory
        writeLines(CODE, "data/x.R")
        
        CODE <- paste0(deparse(substitute({
                y <- 20
                
        })), collapse ="\n")
        
        # save R code in the data directory
        writeLines(CODE, "data/y.R")
        
        CODE <- paste0(deparse(substitute({
                z <- 10
                
        })), collapse ="\n")
        
        # save R code in the data directory
        writeLines(CODE, "data/z.R")
        
        # Read the config data and set sticky_variables to x,y
        config <- translate.dcf("config/global.dcf")
        expect_error(config$sticky_variables <- "x,y", NA)
        write.dcf(config, "config/global.dcf" )
        
        
        # cache should have items in it after a load.project
        suppressMessages(reload.project())
        expect_true(exists("x"))
        expect_true(.read.cache.info("x")$in.cache)
        
        # reload the project with reset and switch off data loading
        suppressMessages(reload.project(override.config=list(data_loading=FALSE),
                                        reset = TRUE))
        
        # Should find the cache empty, even though x is in sticky_variables
        expect_true(!.read.cache.info("x")$in.cache)
        
        
})