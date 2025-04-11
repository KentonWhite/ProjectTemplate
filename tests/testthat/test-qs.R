context("qs cache file format")

skip_if_not_installed("qs")

test_that("cached variable names are assessed correctly", {
  test_project <- tempfile("test_project")
  suppressMessages(create.project(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)
  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  set_cache_file_format("qs")

  var_to_cache <- "cache.qs"
  test_data <- data.frame(Names = c("a", "b", "c"), Ages = c(20, 30, 40))
  assign(var_to_cache, test_data, envir = .TargetEnv)

  cache(var_to_cache)

  expect_identical(
    .cached.variables(),
    var_to_cache
  )

  tidy_up()
})
