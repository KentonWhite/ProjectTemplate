\name{create.project}
\alias{create.project}
\title{
Automatically creates a new project directory and all of its contents.
}
\description{
\code{create.project()} builds a project directory containing several subdirectories and files. The full output is described in the associated README, which can be seen on GitHub.
}
\usage{
create.project(project.name = 'new-project', minimal = FALSE, dump = FALSE)
}
\arguments{
  \item{project.name}{
	A character vector containing the name for this new project. Must be a valid directory name for your file system.
}
	\item{minimal}{
	A boolean value indicating whether to create a minimal project or a full project. A minimal project contains only the directories strictly necessary to use ProjectTemplate and does not provide template code for profiling, unit testing or documenting your project.
}
	\item{dump}{
	A boolean value indicating whether the entire functionality of ProjectTemplate should be written out to flat files in the current project.
}
}
\value{
	No value is returned; this function is called for its side effects.
}
\examples{
\dontrun{
library('ProjectTemplate')

create.project('project_name')}}
