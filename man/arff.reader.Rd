\name{arff.reader}
\alias{arff.reader}
\title{Read the Weka file format.}
\usage{arff.reader(data.file, filename, variable.name)}

\description{
  Read the Weka file format.
}

\details{
  This function will load a data set stored in the Weka
  file format into the specified global variable binding.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{#arff.reader('example.arff', 'data/example.arff', 'example')}
