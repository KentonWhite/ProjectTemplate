context('Templates')

expect_file <- function(..., condition = is_true()) {
  x <- file.path(...)
  expect_that(file.exists(x), condition, x)
}

expect_no_file <- function(...) expect_file(..., condition = is_false())

expect_dir <- function(...) {
  x <- file.path(...)
  expect_file(x)
  expect_true(.is.dir(x))
  expect_file(file.path(x, 'README.md'))
}

expect_full <- function() {
  expect_dir('.')
  expect_dir('cache')
  expect_dir('config')
  expect_file(file.path('config', 'global.dcf'))
  expect_dir('data')
  expect_dir('diagnostics')
  expect_file(file.path('diagnostics', '1.R'))
  expect_dir('docs')
  expect_dir('graphs')
  expect_dir('lib')
  expect_file(file.path('lib', 'helpers.R'))
  expect_dir('logs')
  expect_dir('munge')
  expect_file(file.path('munge', '01-A.R'))
  expect_dir('profiling')
  expect_file(file.path('profiling', '1.R'))
  expect_dir('reports')
  expect_dir('src')
  expect_file(file.path('src', 'eda.R'))
  expect_dir('tests')
  expect_file(file.path('tests', '1.R'))
  expect_file(file.path('TODO'))
}

expect_minimal <- function() {
  expect_dir('.')
  expect_dir('cache')
  expect_dir('config')
  expect_file(file.path('config', 'global.dcf'))
  expect_dir('data')
  expect_dir('munge')
  expect_file(file.path('munge', '01-A.R'))
  expect_dir('src')
  expect_file(file.path('src', 'eda.R'))

  expect_no_file('diagnostics')
  expect_no_file('docs')
  expect_no_file('graphs')
  expect_no_file('lib')
  expect_no_file('logs')
  expect_no_file('profiling')
  expect_no_file('reports')
  expect_no_file('tests')
  expect_no_file('TODO')
}

test_that('creating a template produces at least a minimal project skeleton', {
  test_project <- basename(tempfile('test_project'))
  # Set temporary template as working directory
  expect_error(oldwd <- setwd(tempdir()), NA)
  on.exit(setwd(oldwd), add = TRUE)

  # Create temporary template
  suppressMessages(create.template(test_project))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  expect_error(oldwd <- setwd(test_project), NA)
  on.exit(setwd(oldwd), add = TRUE)
  expect_error(load.project(), NA)

  expect_minimal()
})


test_that('creating a template from "full" produces a full project skeleton', {
  test_project <- basename(tempfile('test_project'))
  # Set temporary template as working directory
  expect_error(oldwd <- setwd(tempdir()), NA)
  on.exit(setwd(oldwd), add = TRUE)

  # Create temporary template
  suppressMessages(create.template(test_project, source = 'full'))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  expect_error(oldwd <- setwd(test_project), NA)
  on.exit(setwd(oldwd), add = TRUE)

  expect_full()
  expect_error(load.project(), NA)
})


test_that('creating a template from an existing template produces the same project skeleton', {
  test_project <- basename(tempfile('test_project'))
  test_project2 <- basename(tempfile('test_project'))
  # Set temporary template as working directory
  expect_error(oldwd <- setwd(tempdir()), NA)
  on.exit(setwd(oldwd), add = TRUE)

  # Create temporary template
  suppressMessages(create.template(test_project, source = 'full'))
  on.exit(unlink(test_project, recursive = TRUE), add = TRUE)

  # Add custom file to template to verify it is copied
  temp_file <- file.path(test_project, 'data', 'file_not_in_full_template.csv')
  write.csv(data.frame(x = 1:4), file = temp_file)

  # Create temporary template from previous template
  suppressMessages(create.template(test_project2, source = test_project))
  on.exit(unlink(test_project2, recursive = TRUE), add = TRUE)

  expect_error(setwd(test_project2), NA)

  expect_full()
  expect_true(file.exists(file.path('data', 'file_not_in_full_template.csv')))
  expect_error(load.project(), NA)
})
