\name{xport.reader}
\alias{xport.reader}
\title{Read an XPort file with a...}
\usage{xport.reader(data.file, filename, variable.name)}

\description{
  Read an XPort file with a .xport file extension.
}

\details{
  This function will load the specified XPort file into
  memory.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#xport.reader('example.xport', 'data/example.xport', 'example')}
