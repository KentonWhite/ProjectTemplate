\name{csv.reader}
\alias{csv.reader}
\title{Read a comma separated values (...}
\usage{csv.reader(data.file, filename, variable.name)}

\description{
  Read a comma separated values (.csv) file.
}

\details{
  This function will load a data set stored in the CSV file
  format into the specified global variable binding.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#csv.reader('example.csv', 'data/example.csv', 'example')}
