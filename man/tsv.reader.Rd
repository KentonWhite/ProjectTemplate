\name{tsv.reader}
\alias{tsv.reader}
\title{Read a tab separated values (...}
\usage{tsv.reader(data.file, filename, variable.name)}

\description{
  Read a tab separated values (.tsv or .tab) file.
}

\details{
  This function will load a data set stored in the TSV file
  format into the specified global variable binding.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#tsv.reader('example.tsv', 'data/example.tsv', 'example')}
