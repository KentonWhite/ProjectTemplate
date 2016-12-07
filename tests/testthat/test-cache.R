context('Caching')

tidy_up <- function () {
        objs <- setdiff(ls(envir = .TargetEnv), "tidy_up")
        rm(list = objs, envir = .TargetEnv)
}


test_that('caching a variable that doesnt exist fails with correct message', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)
  
  var_to_cache <- "xxxx"
  
  # make sure it doesn't exist
  if (exists(var_to_cache, envir = .TargetEnv )) {
          rm(list=var_to_cache, envir = .TargetEnv)
  }
  # try to cache it
  expect_message(cache(var_to_cache, CODE = NULL, depends = NULL), 
                 "Does not exist in global environment and no code to create it")
  tidy_up()
})

test_that('caching a variable not already in cache caches correctly', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        var_to_cache <- "xxxx"
        test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
        assign(var_to_cache, test_data, envir = .TargetEnv)
        
        # Create a new cached version
        expect_message(cache(var_to_cache, CODE = NULL, depends = NULL), 
                       "Creating cache entry from global environment")
        
        # Remove it from Global Environment
        rm(list=var_to_cache, envir = .TargetEnv)
        
        # Load up from cache and check it's the same as what was originally created
        suppressMessages(load.project())
        expect_equal(get(var_to_cache, envir = .TargetEnv) , test_data)
        
        tidy_up()
        
})

test_that('caching a variable created from CODE caches correctly', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        var_to_cache <- "xxxx"
        test_data <- data.frame(Names=c("a", "b", "c"),
                                Ages=c(200,300,400))
        
        
        # Create a cached version created from CODE
        expect_message(cache(var_to_cache, depends = NULL, CODE = {
                                data.frame(Names=c("a", "b", "c"),
                                           Ages=c(200,300,400))
                             }), 
                       "Creating cache entry from CODE")
        
        # Remove it from Global Environment (rm will fail if it's not created from CODE)
        expect_error(rm(list=var_to_cache, envir = .TargetEnv), NA)
        
        # Load up from cache and check it's the same as what was originally created
        suppressMessages(load.project())
        expect_equal(get(var_to_cache, envir = .TargetEnv) , test_data)
        
        tidy_up()
        
})


test_that('re-caching is skipped when a cached variable hasnt changed', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        var_to_cache <- "xxxx"
        test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
        assign(var_to_cache, test_data, envir = .TargetEnv)
        
        # Create initial cached version
        cache(var_to_cache, CODE = NULL, depends = NULL)
        initial_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".RData")))$mtime
        
        # wait two seconds
        Sys.sleep(2)
        
        # Remove it from Global Environment
        rm(list=var_to_cache, envir = .TargetEnv)
        
        # Load up from cache and attempt to re-cache
        suppressMessages(load.project())
        expect_message(cache(var_to_cache, CODE = NULL, depends = NULL), 
                       "Skipping cache update for")
        
        # Check that modification time hasn't changed
        new_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".RData")))$mtime
        
        expect_equal(initial_mtime, new_mtime)
        
        tidy_up()
        
})

test_that('re-caching is done again when a cached variable has changed', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        var_to_cache <- "xxxx"
        test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
        assign(var_to_cache, test_data, envir = .TargetEnv)
        
        # Create initial cached version
        cache(var_to_cache, CODE = NULL, depends = NULL)
        initial_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".RData")))$mtime
        
        # wait two seconds
        Sys.sleep(2)
        
        # Remove it from Global Environment
        rm(list=var_to_cache, envir = .TargetEnv)
        
        # Load up from cache 
        suppressMessages(load.project())
        
        # change the variable and attempt to re-cache
        test_data2 <- data.frame(Names=c("aaa", "b", "c"), Ages=c(20,30,40))
        assign(var_to_cache, test_data2, envir = .TargetEnv)
        
        expect_message(cache(var_to_cache, CODE = NULL, depends = NULL), 
                       "Updating existing cache entry from global environment")
        
        # Check that modification time has changed
        new_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".RData")))$mtime
        expect_false(isTRUE(all.equal(initial_mtime, new_mtime)))
        
        # Reload and check that re-cached value is different
        rm(list=var_to_cache, envir = .TargetEnv)
        suppressMessages(load.project())
        
        expect_false(isTRUE(all.equal(get(var_to_cache, envir = .TargetEnv) , test_data)))
        
        tidy_up()
        
})

test_that('re-caching fails with correct message if cached variable is not in global env', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        var_to_cache <- "xxxx"
        test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
        assign(var_to_cache, test_data, envir = .TargetEnv)
        
        # Create initial cached version
        cache(var_to_cache, CODE = NULL, depends = NULL)
        initial_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".RData")))$mtime
        
        # wait two seconds
        Sys.sleep(2)
        
        # Remove it from Global Environment
        rm(list=var_to_cache, envir = .TargetEnv)
        
        # Load up from cache 
        suppressMessages(load.project())
        
        # And remove it from Global Environment again
        rm(list=var_to_cache, envir = .TargetEnv)
        
        expect_message(cache(var_to_cache, CODE = NULL, depends = NULL), 
                       "Unable to update cache for")
        
        # Check that modification time hasn't changed
        new_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".RData")))$mtime
        expect_equal(initial_mtime, new_mtime)
        
        tidy_up()
        
})

test_that('re-caching a variable created from CODE only happens if code changes, not comments or white space', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        var_to_cache <- "xxxx"
        test_data <- data.frame(Names=c("a", "b", "c"),
                                Ages=c(20000000,300,400))
        
        
        # Create a cached version created from CODE
        expect_message(cache(var_to_cache, depends = NULL, CODE = {
                data.frame(Names=c("a", "b", "c"),
                           Ages=c(200,300,400))
        }), 
        "Creating cache entry from CODE")
        
        initial_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".RData")))$mtime
        
        # wait two seconds
        Sys.sleep(2)
        
        # Remove it from Global Environment (rm will fail if it's not created from CODE)
        expect_error(rm(list=var_to_cache, envir = .TargetEnv), NA)
        
        # Load up from cache again
        suppressMessages(load.project())
        
        # re-cache, this time adding some comments and whitespace, but not changing code
        # should skip re-caching
        expect_message(cache(var_to_cache, depends = NULL, CODE = {
                #  New comments add in
                data.frame(Names=c("a", "b", "c"),
                           Ages=c(200,300,400))    # but code remains the same
                
                # extra new lines added for good measure
        }), 
        "Skipping cache update for ")
        
        # Check that modification time hasn't changed
        new_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".RData")))$mtime
        
        expect_equal(initial_mtime, new_mtime)
        
        # re-cache agin, keeping the comments and whitespace, but changing the code
        expect_message(cache(var_to_cache, depends = NULL, CODE = {
                #  New comments add in
                data.frame(Names=c("a", "b", "c"),
                           Ages=c(20000000,300,400))    # but code remains the same
                
                # extra new lines added for good measure
        }), 
        "Updating existing cache entry from CODE")
        
        # Check that modification time has also changed
        new_mtime <- file.info(file.path('cache', paste0(var_to_cache, ".RData")))$mtime
        expect_false(isTRUE(all.equal(initial_mtime, new_mtime)))
        
        # Finally check that the new code evaluated correctly
        expect_equal(get(var_to_cache, envir = .TargetEnv) , test_data)
        
        tidy_up()
        
})

test_that('caching a variable with an underscore is not unnecessarily loaded next load.project()', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        var_to_cache <- "xx_xx"
        test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
        assign(var_to_cache, test_data, envir = .TargetEnv)
        
        # Create a new cached version
        expect_message(cache(var_to_cache, CODE = NULL, depends = NULL), 
                       "Creating cache entry from global environment")
        
        # Load up from cache and check no message contains an x
        expect_message(load.project(), "[^[^x]+$")
        
        
        tidy_up()
        
})

test_that('caching a variable using CODE doesnt leave variables in globalenv', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        var_to_cache <- "xxxx"
        
        # make sure it doesn't exist
        if (exists(var_to_cache, envir = .TargetEnv )) {
                rm(list=var_to_cache, envir = .TargetEnv)
        }
        
        # set an environment variable in global env
        assign("yyy", 10, envir = .TargetEnv)
        
        # create a cached variable 
        cache(var_to_cache, CODE = {
                aaa <- 10
                bbb <- 10
                aaa*bbb*yyy
        })
        
        # check variable calculates correctly
        expect_equal(get(var_to_cache), 10*10*10)
        
        # Make sure local variables don't exist in global env
        expect_true(!exists("aaa"))
        expect_true(!exists("bbb"))
                       
        tidy_up()
})
