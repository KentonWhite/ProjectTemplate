\name{es.reader}
\alias{es.reader}
\title{Read an ElasticSearch index described in a .es file.}
\usage{
es.reader(data.file, filename, variable.name)
}
\arguments{
  \item{data.file}{The name of the data file to be read.}

  \item{filename}{The path to the data set to be loaded.}

  \item{variable.name}{The name to be assigned to in the
  global environment.}
}
\value{
No value is returned; this function is called for its side
effects.
}
\description{
This function will load data from an ElasticSearch index
based on configuration information found in the specified
.es file. The .es file must specify an ElasticSearch sercer
to be accessed. A specific query against any index may be
executed to generate a data set.
}
\details{
Example of the DCF format and settings used in a .es file
are shown below:

host: localhost port: 9200 index: sample_index field: text
query: this AND that
}
\examples{
library('ProjectTemplate')

\dontrun{es.reader('example.es', 'data/example.es', 'example')}
}

