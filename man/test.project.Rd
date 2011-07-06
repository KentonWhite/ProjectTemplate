\name{test.project}
\alias{test.project}
\title{Run all unit tests for this project.}

\description{
  Run all unit tests for this project.
}

\details{
  This function will run all of the \code{testthat} style
  unit tests for the current project that are defined
  inside of the \code{tests} directory. The tests will be
  run in the order defined by the filenames for the tests:
  it is recommend that each test begin with a number
  specifying its position in the sequence.
}
\value{No value is returned; this function is called for its side effects.}
\examples{library('ProjectTemplate')

#load.project()

#test.project()}
