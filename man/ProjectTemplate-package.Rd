\name{ProjectTemplate-package}
\alias{ProjectTemplate-package}
\alias{ProjectTemplate}
\docType{package}
\title{
Automates the creation of new R statistical analysis projects.
}
\description{
The ProjectTemplate package provides a single function `create.project()` that automatically builds a directory for a new R project with a clean sub-directory structure and automatic data and library loading tools. The hope is that standardized data loading, automatic importing of best practice packages, integrated unit testing and useful nudges towards keeping a cleanly organized codebase will improve the quality of R coding. At least, it will hopefully improve my own code.
}
\details{
\tabular{ll}{
Package: \tab ProjectTemplate\cr
Type: \tab Package\cr
Version: \tab .1\cr
Date: \tab 2010-08-24\cr
License: \tab Artistic-2.0\cr
LazyLoad: \tab yes\cr
}
create.project('project_name')
}
\references{
This code is inspired by Ruby on Rails.
}
\keyword{ package }
\examples{
library('ProjectTemplate')

create.project('project_name')

setwd('project_name')

load.project()}
