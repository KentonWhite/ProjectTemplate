test_that("Cleans variable names with underscore when underscore_variables = TRUE", {
    test_project <- tempfile("test_project")
    suppressMessages(create.project(basename(test_project), project.directory = dirname(test_project)))
    on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

    oldwd <- setwd(test_project)
    on.exit(setwd(oldwd), add = TRUE)

    config$underscore_variables <- TRUE
    .save.config(config)

    suppressMessages(load.project())

    expect_equal(clean.variable.name("test_me"), "test_me")
    expect_equal(clean.variable.name("test-me"), "test.me")
    expect_equal(clean.variable.name("test..me"), "test.me")
    expect_equal(clean.variable.name("test me"), "test.me")
    expect_equal(clean.variable.name("1990"), "X1990")
})

test_that("Cleans variable names without underscore when underscore_variables = FALSE", {
    test_project <- tempfile("test_project")
    suppressMessages(create.project(basename(test_project), project.directory = dirname(test_project)))
    on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

    oldwd <- setwd(test_project)
    on.exit(setwd(oldwd), add = TRUE)

    config$underscore_variables <- FALSE
    .save.config(config)

    suppressMessages(load.project(underscore_variables = FALSE))

    expect_equal(clean.variable.name("test_me"), "test.me")
    expect_equal(clean.variable.name("test-me"), "test.me")
    expect_equal(clean.variable.name("test..me"), "test.me")
    expect_equal(clean.variable.name("test me"), "test.me")
    expect_equal(clean.variable.name("1990"), "X1990")
})
