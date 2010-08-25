\name{ProjectTemplate-package}
\alias{ProjectTemplate-package}
\alias{ProjectTemplate}
\docType{package}
\title{
Automates the creation of new R statistical analysis projects.
}
\description{
The ProjectTemplate package provides a single function create.project() that automatically builds a directory for a new R project with a clean directory structure and useful utility programs for automating the loading of project data. The hope is that standardized and automated data loading, automatic loading of best practice packages and useful nudges towards keeping cleanly organized code will improve the quality of R coding.
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
\author{
John Myles White

Maintainer: John Myles White <jmw@johnmyleswhite.com>
}
\references{
This code is inspired by Ruby on Rails.
}
\keyword{ package }
\examples{
library('ProjectTemplate')

create.project('project_name')}
