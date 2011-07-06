\name{run.project}
\alias{run.project}
\title{Run all of the analyses in the src directory.}

\description{
  Run all of the analyses in the \code{src} directory.
}

\details{
  This function will run each of the analyses in the
  \code{src} directory in separate processes. At present,
  this is done serially, but future versions of this
  function will provide a means of running the analyses in
  parallel.
}
\value{No value is returned; this function is called for its side effects.}
\examples{library('ProjectTemplate')

#run.project()}
