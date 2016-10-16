context('Migration')

expect_defaults <- function(config) {
  expect_true(is.character(config$version))
  expect_true(config$attach_internal_libraries)
}

lapply(
  c("0.5", "0.5-2"),
  function(version) {
    test_that(paste('Version', version), {
      projdir <- tempfile("PT-test-")
      dir.create(projdir)
      file.copy(dir(file.path('migration', version), full.names = T), projdir, recursive = TRUE)
      oldwd <- setwd(projdir)
      on.exit(setwd(oldwd), add = TRUE)

      expect_that(suppressMessages(load.project()), gives_warning("migrate.project"))
      on.exit(.unload.project(), add = TRUE)

      expect_warning(suppressMessages(migrate.project()), "missing the following entries")
      expect_warning(suppressMessages(load.project()), NA)
      expect_defaults(get.project()$config)
    })
  }
)


test_that('projects without the cached_loaded_data config have their migrated config set to FALSE ', {
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # Read the config data and remove the cache_loaded_data flag
        config <- as.data.frame(read.dcf("config/global.dcf"))
        expect_error(config$cache_loaded_data <- NULL, NA)
        write.dcf(config, "config/global.dcf" )
        
        # should get a warning because of the missing cache_loaded_data
        expect_warning(suppressMessages(load.project()), "missing the following entries")
        
        test_data <- data.frame(Names=c("a", "b", "c"), Ages=c(20,30,40))
        
        # save test data as a csv in the data directory
        write.csv(test_data, file="data/test.csv", row.names = FALSE)
        
        # Migrate the project
        expect_message(migrate.project(), "new config item called cache_loaded_data")
        
        # Read the config data and check cached_loaded_data is FALSE
        config <- as.data.frame(read.dcf("config/global.dcf"), stringsAsFactors=FALSE)
        expect_equal(config$cache_loaded_data, "FALSE")
        
        # Should be a clean load.project
        expect_warning(suppressMessages(load.project()), NA)
        
        # check that the the test variable has not been cached
        expect_error(load("cache/test.RData", envir = environment()), "cannot open the connection")
        
        
})


