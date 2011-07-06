\name{db.reader}
\alias{db.reader}
\title{Read a SQlite3 database with a (...}
\usage{db.reader(data.file, filename, variable.name)}

\description{
  Read a SQlite3 database with a (.db) file extension.
}

\details{
  This function will load all of the data sets stored in
  the SQlite3 database into the global environment. If you
  want to specify a single table or query to execute
  against the database, move it elsewhere and use a .sql
  file interpreted by \code{\link{sql.reader}}.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{data.file}{The name of the data file to be read.}
  \item{filename}{The path to the data set to be loaded.}
  \item{variable.name}{The name to be assigned to in the global environment.}
}
\examples{library('ProjectTemplate')

#db.reader('example.db', 'data/example.db', 'example')}
