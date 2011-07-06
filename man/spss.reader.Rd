\name{spss.reader}
\alias{spss.reader}
\title{Read an SPSS file with a...}
\usage{spss.reader(data.file, filename, variable.name)}

\description{
  Read an SPSS file with a .sav file extension.
}

\details{
  This function will load the specified SPSS file into
  memory. It will convert the resulting list object into a
  data frame before inserting the data set into the global
  environment.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#spss.reader('example.sav', 'data/example.sav', 'example')}
