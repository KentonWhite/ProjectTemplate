library('testthat')

library('ProjectTemplate')

create.project('test_project')

expect_that(file.exists(file.path('test_project')), is_true())
expect_that(file.exists(file.path('test_project', 'data')), is_true())
expect_that(file.exists(file.path('test_project', 'diagnostics')), is_true())
expect_that(file.exists(file.path('test_project', 'doc')), is_true())
expect_that(file.exists(file.path('test_project', 'graphs')), is_true())
expect_that(file.exists(file.path('test_project', 'lib')), is_true())
expect_that(file.exists(file.path('test_project', 'profiling')), is_true())
expect_that(file.exists(file.path('test_project', 'reports')), is_true())
expect_that(file.exists(file.path('test_project', 'tests')), is_true())
expect_that(file.exists(file.path('test_project', 'README')), is_true())
expect_that(file.exists(file.path('test_project', 'TODO')), is_true())
expect_that(file.exists(file.path('test_project', 'lib', 'boot.R')), is_true())
expect_that(file.exists(file.path('test_project', 'lib', 'load_data.R')), is_true())
expect_that(file.exists(file.path('test_project', 'lib', 'load_libraries.R')), is_true())
expect_that(file.exists(file.path('test_project', 'lib', 'preprocess_data.R')), is_true())
expect_that(file.exists(file.path('test_project', 'lib', 'utilities.R')), is_true())

unlink('test_project', recursive = TRUE)
