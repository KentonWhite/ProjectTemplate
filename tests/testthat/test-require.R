context('Require package')

test_that('.require.package warns if compat setting is set', {

  test_project <- tempfile('test_project')
  suppressMessages(create.project(test_project, minimal = FALSE))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  oldwd <- setwd(test_project)
  on.exit(setwd(oldwd), add = TRUE)

  suppressMessages(.unload.project())
  expect_false(.has.project())
  suppressMessages(load.project())
  expect_true(.has.project())

  expect_false(project.info$config$attach_internal_libraries)
  expect_that(.require.package('ProjectTemplate'), not(gives_warning()))

  project.info$config[['attach_internal_libraries']] <<- TRUE
  expect_true(project.info$config[['attach_internal_libraries']])
  expect_true(get.project()$config$attach_internal_libraries)
  expect_that(.require.package('ProjectTemplate'), gives_warning('attach_internal_libraries'))
})
