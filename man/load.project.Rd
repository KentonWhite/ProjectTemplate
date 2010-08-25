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
\arguments{
}
\value{
	No value is returned; this function is called for its side effects.
}
\examples{
library('ProjectTemplate')

create.project('project_name')

setwd('project_name')

load.project()}
