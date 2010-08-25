\name{load.project}
\alias{load.project}
\title{
Automatically load all of the data and libraries used by the current project.
}
\description{
Automatically load all of the data and libraries used by the current project.
}
\usage{
load.project()
}
\value{
	No value is returned; this function is called for its side effects.
}
\examples{
\dontrun{
library('ProjectTemplate')

create.project('project_name')

setwd('project_name')

load.project()}}
