library('testthat')

library('ProjectTemplate')

# Test deprecation of project.info.

create.project('test_project', minimal = FALSE)

setwd('test_project')

load.project()

expect_that(project.info, gives_warning("deprecated"))
expect_that(project.info, not(gives_warning()))
expect_identical(project.info, get.project())

setwd('..')

unlink('test_project', recursive = TRUE)
