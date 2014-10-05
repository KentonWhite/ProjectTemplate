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
      expect_that(suppressMessages(load.project()), not(gives_warning()))
      expect_defaults(get.project()$config)
    })
  }
)
