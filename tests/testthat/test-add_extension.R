context("AddExtension")

test_that("Test 1a: Add a new style extension", {
  foo1.reader <- function(filename, variable.name, ...) {
    list(
      "file.name" = filename,
      "variable.name" = variable.name,
      "..." = list(...)
    )
  }
  on.exit(rm(list = "\\.foo1$", envir = extensions.dispatch.table), add = TRUE)

  .add.extension("foo1", foo1.reader)
  expect_true("\\.foo1$" %in% names(extensions.dispatch.table))
  expect_identical(extensions.dispatch.table[["\\.foo1$"]]$name, "foo1.reader")
  expect_identical(extensions.dispatch.table[["\\.foo1$"]]$reader, foo1.reader)
})

test_that("Test 1b: Add a new style extension by name", {
  foo2.reader <- function(filename, variable.name, ...) {
    list(
      "file.name" = file.name,
      "variable.name" = variable.name,
      "..." = list(...)
    )
  }
  on.exit(rm(list = "\\.foo1$", envir = extensions.dispatch.table), add = TRUE)

  .add.extension("foo1", "foo2.reader")
  expect_true("\\.foo1$" %in% names(extensions.dispatch.table))
  expect_identical(extensions.dispatch.table[["\\.foo1$"]]$name, "foo2.reader")
  expect_identical(extensions.dispatch.table[["\\.foo1$"]]$reader, foo2.reader)
})

test_that("Test 2: Add an old style extension", {
  test_reader_old_style <- function(data.file, filename, variable.name) {
    return(list(data.file = data.file,
                filename = filename,
                variable.name = variable.name))
  }
  on.exit(rm(list = "\\.foo1$", envir = extensions.dispatch.table),
          add = TRUE)

  # Expect the deprecation warning
  .add.extension("foo1", test_reader_old_style)

  # Expect the extension was added to the dispatch table
  expect_true("\\.foo1$" %in% names(extensions.dispatch.table))
  reader <- extensions.dispatch.table[["\\.foo1$"]]

  expect_identical(reader$name, "test_reader_old_style")
  expect_is(reader$reader, "function")

  expect_warning(output <- reader$reader(filename = 'data/example.foo1',
                                         variable.name = 'example',
                                         test = 'testing ...'),
                 "reader with non-standard arguments")
  test_output <- list(data.file = 'example.foo1',
                      filename = 'data/example.foo1',
                      variable.name = 'example')
  expect_identical(output, test_output)
})

test_that("Test 3: Add an old style extension and load from lib/", {
  test_project <- tempfile("test_project")
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  on.exit(rm(list = "\\.foo$", envir = extensions.dispatch.table), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  file.copy(file.path(system.file("example_data", package = "ProjectTemplate"),
                      "foo.reader.R"),
            file.path("lib", "foo.reader.R"))
  file.copy(file.path(system.file("example_data", package = "ProjectTemplate"),
                      "example.foo"),
            file.path("data", "example.foo"))

  expect_true(file.exists(file.path("lib", "foo.reader.R")))
  expect_true(file.exists(file.path("data", "example.foo")))

  expect_warning(load.project(), "reader with non-standard arguments")
  expect_true("\\.foo$" %in% names(extensions.dispatch.table))
  expect_identical(extensions.dispatch.table[["\\.foo$"]]$name, "foo.reader")
  expect_identical(get("example", envir = .GlobalEnv), "bar")
})
