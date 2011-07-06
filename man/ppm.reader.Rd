\name{ppm.reader}
\alias{ppm.reader}
\title{Read a PPM file with a...}
\usage{ppm.reader(data.file, filename, variable.name)}

\description{
  Read a PPM file with a .ppm file extension.
}

\details{
  This function will load the specified PPM file into
  memory using the pixamp package. This is useful for
  working with image files as a data set.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#ppm.reader('example.ppm', 'data/example.ppm', 'example')}
