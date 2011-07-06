\name{stata.reader}
\alias{stata.reader}
\title{Read a Stata file with a...}
\usage{stata.reader(data.file, filename, variable.name)}

\description{
  Read a Stata file with a .stata file extension.
}

\details{
  This function will load the specified Stata file into
  memory.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#stata.reader('example.stata', 'data/example.stata', 'example')}
