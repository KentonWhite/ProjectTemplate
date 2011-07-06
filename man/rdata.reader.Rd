\name{rdata.reader}
\alias{rdata.reader}
\title{Read an RData file with a...}
\usage{rdata.reader(data.file, filename, variable.name)}

\description{
  Read an RData file with a .rdata or .rda file extension.
}

\details{
  This function will load the specified RData file into
  memory using the \code{\link{load}} function. This may
  generate many data sets simultaneously.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#rdata.reader('example.RData', 'data/example.RData', 'example')}
