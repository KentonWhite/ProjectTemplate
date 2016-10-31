context('Migration')

# Function to tidy up at the end of tests
tidy_up <- function () {
        objs <- setdiff(ls(envir = .TargetEnv), "tidy_up")
        rm(list = objs, envir = .TargetEnv)
}


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

      expect_message(migrate.project(), "file was missing entries")
      expect_warning(suppressMessages(load.project()), NA)
      expect_defaults(get.project()$config)
    })
  }
)

test_that('migrating a project which doesnt need config update results in an Up to date message', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # should be nothing
        expect_message(migrate.project(), "Already up to date")
        tidy_up()
})


test_that('migrating a project with a missing config file results in a message to user', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        # remove the config file
        unlink('config/global.dcf')
        
        # should be a message to say no config file
        expect_message(migrate.project(), "didn't have a config\\.dcf file")
        
        
        suppressMessages(load.project())
        
        # Get the default config
        default_config <- .read.config(.default.config.file)
        default_config$version <- .package.version()
        
        # check the config is all the default
        expect_equal(get.project()$config, default_config)
        
        tidy_up()
})



test_that('migrating a project with a missing config item results in a message to user', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        suppressMessages(load.project())
        
        # remove the config item
        config$data_loading <- NULL
        .save.config(config)
        
        # should be a message to say no config item
        expect_message(migrate.project(), "data_loading")
        
        suppressMessages(load.project())
        
        # check the missing config item is the default value
        default_config <- .read.config(.default.config.file)
        expect_equal(get.project()$config$data_loading, default_config$data_loading)
        
        tidy_up()
})


test_that('migrating a project with a dummy config item results in a message to user', {
        
        test_project <- tempfile('test_project')
        suppressMessages(create.project(test_project, minimal = FALSE))
        on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
        
        oldwd <- setwd(test_project)
        on.exit(setwd(oldwd), add = TRUE)
        
        suppressMessages(load.project())
        
        # add the dummy config item
        config$dummy <- TRUE
        .save.config(config)
        
        # should be a message to say no config item
        expect_message(migrate.project(), "dummy")
        
        suppressMessages(load.project())
        
        # check that the dummy config item is not in the config
        expect_null(get.project()$config$dummy)
        
        tidy_up()
})

