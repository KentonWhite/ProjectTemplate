\name{octave.reader}
\alias{octave.reader}
\title{Read an Octave file with a...}
\usage{octave.reader(data.file, filename, variable.name)}

\description{
  Read an Octave file with a .m file extension.
}

\details{
  This function will load the specified Octave file into
  memory.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#octave.reader('example.m', 'data/example.m', 'example')}
