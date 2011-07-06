\name{systat.reader}
\alias{systat.reader}
\title{Read a Systat file with a...}
\usage{systat.reader(data.file, filename, variable.name)}

\description{
  Read a Systat file with a .sys or .syd file extension.
}

\details{
  This function will load the specified Systat file into
  memory.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#systat.reader('example.sys', 'data/example.sys', 'example')}
