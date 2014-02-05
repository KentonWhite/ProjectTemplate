\name{create.project}
\alias{create.project}
\title{Create a new project.}
\usage{
create.project(project.name = "new-project", minimal = FALSE,
  dump = FALSE, merge.existing = FALSE)
}
\arguments{
  \item{project.name}{A character vector containing the
  name for this new project. Must be a valid directory name
  for your file system.}

  \item{minimal}{A boolean value indicating whether to
  create a minimal project or a full project. A minimal
  project contains only the directories strictly necessary
  to use ProjectTemplate and does not provide template code
  for profiling, unit testing or documenting your project.}

  \item{dump}{A boolean value indicating whether the entire
  functionality of ProjectTemplate should be written out to
  flat files in the current project.}

  \item{merge.existing}{If \code{TRUE}, allow merging into
  an existing directory unless files or directories would
  be overwritten there.  If \code{FALSE} and the
  \code{project.name} directory exists, it must be empty.}
}
\value{
No value is returned; this function is called for its side effects.
}
\description{
This function will create all of the scaffolding for a new project.
It will set up all of the relevant directories and their initial
contents. For those who only want the minimal functionality, the
\code{minimal} argument can be set to \code{TRUE} to create a subset of
ProjectTemplate's default directories. For those who want to dump
all of ProjectTemplate's functionality into a directory for extensive
customization, the \code{dump} argument can be set to \code{TRUE}.
}
\details{
If the target directory does not exist, it is created.  Otherwise,
  it must be empty or (if \code{merge.existing} is \code{TRUE}) it must
  not contain files or directories with the same name as the files and
  directories to be copied.
}
\examples{
library('ProjectTemplate')

\dontrun{create.project('MyProject')}
}

