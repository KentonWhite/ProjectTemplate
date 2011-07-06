\name{mp3.reader}
\alias{mp3.reader}
\title{Read an MP3 file with a...}
\usage{mp3.reader(data.file, filename, variable.name)}

\description{
  Read an MP3 file with a .mp3 file extension.
}

\details{
  This function will load the specified MP3 file into
  memory using the tuneR package. This is useful for
  working with music files as a data set.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#mp3.reader('example.mp3', 'data/example.mp3', 'example')}
