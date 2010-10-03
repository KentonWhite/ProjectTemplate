\name{run.tests}
\alias{run.tests}
\alias{test.project}
\title{
Automatically run all of the tests cases in the tests directory.
}
\description{
Automatically run all of the tests cases in the tests directory.
}
\usage{
run.tests()
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

run.tests()}}
