\name{create.project}
\alias{create.project}
\title{
Automatically creates a new project directory and all of its contents.
}
\description{
create.project() builds a project directory containing several sub-directories and files. The full output is described in the associated README, which can be seen on GitHub.
}
\usage{
create.project(project.name)
}
\arguments{
  \item{project.name}{
	A character vector containing the name for this new project. Must be a valid directory name for your file system.
}
}
\value{
	No value is returned; this function is called for its side effects.
}
\examples{
\dontrun{
library('ProjectTemplate')

create.project('project_name')}}
