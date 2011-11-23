\name{sql.reader}
\alias{sql.reader}
\title{Read a database described in a .sql file.}
\usage{
  sql.reader(data.file, filename, variable.name)
}
\arguments{
  \item{data.file}{The name of the data file to be read.}

  \item{filename}{The path to the data set to be loaded.}

  \item{variable.name}{The name to be assigned to in the
  global environment.}
}
\value{
  No value is returned; this function is called for its
  side effects.
}
\description{
  This function will load data from a SQL database based on
  configuration information found in the specified .sql
  file. The .sql file must specify a database to be
  accessed. All tables from the database, one specific
  tables or one specific query against any set of tables
  may be executed to generate a data set.
}
\details{
  Examples of the DCF format and settings used in a .sql
  file are shown below:

  Example 1 type: mysql user: sample_user password:
  sample_password host: localhost dbname: sample_database
  table: sample_table

  Example 2 type: sqlite dbname: /path/to/sample_database
  table: sample_table

  Example 3 type: sqlite dbname: /path/to/sample_database
  query: SELECT * FROM users WHERE user_active == 1

  Example 4 type: sqlite dbname: /path/to/sample_database
  table: *

  Example 5 type: postgres user: sample_user password:
  sample_password host: localhost dbname: sample_database
  table: sample_table

  Example 6 type: odbc dsn: sample_dsn user: sample_user
  password: sample_password dbname: sample_database query:
  SELECT * FROM sample_table
}
\examples{
library('ProjectTemplate')

\dontrun{sql.reader('example.sql', 'data/example.sql', 'example')}
}

