\name{show.project}
\alias{show.project}
\title{Show information about the current project.}

\description{
  Show information about the current project.
}

\details{
  This function will show the user all of the information
  that ProjectTemplate has about the current project. This
  information is gathered when \code{\link{load.project}}
  is called. At present, ProjectTemplate keeps a record of
  the project's configuration settings, all packages that
  were loaded automatically and all of the data sets that
  were loaded automatically. The information about
  autoloaded data sets is used by the
  \code{\link{cache.project}} function.
}
\value{No value is returned; this function is called for its side effects.}
\examples{library('ProjectTemplate')

#load.project()

#show.project()}
