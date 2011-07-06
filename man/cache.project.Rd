\name{cache.project}
\alias{cache.project}
\title{Cache a project's data sets in binary format.}

\description{
  Cache a project's data sets in binary format.
}

\details{
  This function will cache all of the data sets that were
  loaded by the \code{\link{load.project}} function in a
  binary format that is easier to load quickly. This is
  particularly useful for data sets that you've modified
  during a slow munging process that does not need to be
  repeated.
}
\value{No value is returned; this function is called for its side effects.}
\examples{library('ProjectTemplate')
#load.project()

#cache.project()}
