\name{run.project}
\alias{run.project}
\title{
Automatically run all of the analysis scripts in the src directory.
}
\description{
Automatically run all of the analysis scripts in the src directory.
}
\usage{
run.project()
}
\value{
	No value is returned; this function is called for its side effects.
}
\examples{
\dontrun{
library('ProjectTemplate')

create.project('project_name')

setwd('project_name')

run.project()}}
