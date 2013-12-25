library('testthat')

library('ProjectTemplate')

foo.reader <- function() {}
	
ProjectTemplate:::add.extension('foo', foo.reader)
expect_that(ProjectTemplate:::extensions.dispatch.table[['\\.foo$']], equals(foo.reader))

rm(foo.reader)