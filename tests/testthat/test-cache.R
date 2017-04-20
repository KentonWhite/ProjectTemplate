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

test_that('cache and memory is cleared correctly', {

        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        var_to_cache <- "xxxx"

        test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
        assign(var_to_cache, test_data, envir = .TargetEnv)
        
        # Create a new cached version
        expect_message(cache("xxxx"), 
                       "Creating cache entry from global environment")
        
        # clear from memory
        clear("xxxx", force = TRUE)
        
        # Read the config and set config$sticky_variables
        cfg <- .read.config()
        cfg$sticky_variables <- var_to_cache
        .save.config(cfg)
        
        # variable is loaded into memory when load.project is run
        expect_message(load.project(), "Loading cached data set: xxxx")
        
        # variable exists in cache
        expect_message(cache(), "Variable: xxxx")
        
        # variable should still be in memory
        expect_message(clear(), "not cleared: config xxxx")
        
        # variable exists in memory
        expect_true(exists("xxxx"))
        
        # delete variable from cache
        expect_message(clear.cache(), "Removed successfully")
        
        # variable does not exist in memory, should have been forced cleared
        expect_true(!exists("xxxx"))
        
        # shouldn't be anything in the cache
        expect_message(cache(), "No variables in cache")
        
        tidy_up()
        
})


test_that('multiple items are cleared correctly from the cache', {
        
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        assign("xxx", 10, envir = .TargetEnv)
        assign("yyy", 20, envir = .TargetEnv)
        assign("zzz", 30, envir = .TargetEnv)
        
        # Create cached version of each of these
        expect_message(cache("xxx"), 
                       "Creating cache entry from global environment")
        
        expect_message(cache("yyy"), 
                       "Creating cache entry from global environment")
        
        expect_message(cache("zzz"), 
                       "Creating cache entry from global environment")
        
        
        # clear two variables from cache
        expect_message(clear.cache("yyy", "zzz"), "Removed successfully ")
        
        # Check variables not in global env
        expect_true(!exists("yyy"))
        expect_true(!exists("zzz"))
        
        # clear everything and reload project
        clear(force = TRUE)
        # variable is loaded into memory when load.project is run
        expect_message(load.project(), "Loading cached data set: xxx")
        
        expect_equal(xxx, 10)
        
        # variable exists in memory
        expect_true(exists("xxx"))
        
        # Check variables still not in global env
        expect_true(!exists("yyy"))
        expect_true(!exists("zzz"))
        
        
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

test_that('caching a variable already in cache with no hash file re-caches correctly', {
        
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
        
        # delete the hash file
        unlink(file.path("cache", paste0(var_to_cache, ".hash")))
        
        # Create another cached version:  should be created from new again
        expect_message(cache(var_to_cache, CODE = NULL, depends = NULL), 
                       "Creating cache entry from global environment")
        
        # Check that the hash file exists
        expect_true(file.exists(file.path("cache", paste0(var_to_cache, ".hash"))))
        
        # Load up from cache and check it's the same as what was originally created
        suppressMessages(load.project())
        expect_equal(get(var_to_cache, envir = .TargetEnv) , test_data)
        
        tidy_up()
        
})

