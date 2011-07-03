\name{test.project}
\alias{test.project}
\title{
Automatically run all of the tests cases in the tests directory.
}
\description{
Automatically run all of the tests cases in the tests directory.
}
\usage{
test.project()
}
\value{
	No value is returned; this function is called for its side effects.
}
\examples{
\dontrun{
library('ProjectTemplate')

create.project('project_name')

setwd('project_name')

load.project()

test.project()}}
