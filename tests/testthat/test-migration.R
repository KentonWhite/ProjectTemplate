context('Migration')

expect_defaults <- function(config, version) {
  expect_true(is.character(config$version))
  expect_equal(config$attach_internal_libraries, compareVersion(version, '0.6-1') < 0)
}

orig_dir <- system.file(file.path("defaults", "migrate"), package = "ProjectTemplate")
orig_files <- dir(orig_dir, full.names = TRUE)

lapply(
  orig_files,
  function(orig_file) {
    tar_name <- basename(orig_file)
    version <- gsub("[.]tar$", "", tar_name)
    test_that(sprintf('Migration results in projects that load without warnings: %s', version), {
      test_project_base <- tempfile('test_project')
      expect_that(file.exists(file.path(test_project_base)), is_false())
      untar(tarfile = orig_file, exdir = test_project_base)
      on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
      expect_that(file.exists(file.path(test_project_base)), is_true())

      test_project <- file.path(test_project_base, "full")

      oldwd <- setwd(test_project)
      on.exit(setwd(oldwd), add = TRUE)

      expect_that(suppressMessages(load.project()), gives_warning("migrate.project"))
      on.exit(.unload.project(), add = TRUE)

      #migrate.project()
      suppressMessages(migrate.project())
      expect_that(suppressMessages(load.project()), not(gives_warning()))
      expect_defaults(get.project()$config, version)
    })
  }
)
