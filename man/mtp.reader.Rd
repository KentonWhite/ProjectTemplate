\name{mtp.reader}
\alias{mtp.reader}
\title{Read a Minitab Portable Worksheet with an...}
\usage{mtp.reader(data.file, filename, variable.name)}

\description{
  Read a Minitab Portable Worksheet with an .mtp3 file
  extension.
}

\details{
  This function will load the specified Minitab Portable
  Worksheet into memory.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#mtp.reader('example.mtp', 'data/example.mtp', 'example')}
