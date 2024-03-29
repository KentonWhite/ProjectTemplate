% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/preinstalled.readers.R, R/arff.reader.R,
%   R/csv.reader.R, R/csv2.reader.R, R/db.reader.R, R/dbf.reader.R,
%   R/epiinfo.reader.R, R/feather.reader.R, R/file.reader.R, R/mp3.reader.R,
%   R/mtp.reader.R, R/octave.reader.R, R/ppm.reader.R, R/r.reader.R,
%   R/rdata.reader.R, R/rds.reader.R, R/spss.reader.R, R/sql.reader.R,
%   R/stata.reader.R, R/systat.reader.R, R/tsv.reader.R, R/url.reader.R,
%   R/wsv.reader.R, R/xls.reader.R, R/xlsx.reader.R, R/xport.reader.R
\docType{data}
\name{preinstalled.readers}
\alias{preinstalled.readers}
\alias{arff.reader}
\alias{csv.reader}
\alias{csv2.reader}
\alias{db.reader}
\alias{dbf.reader}
\alias{epiinfo.reader}
\alias{feather.reader}
\alias{file.reader}
\alias{mp3.reader}
\alias{mtp.reader}
\alias{octave.reader}
\alias{ppm.reader}
\alias{r.reader}
\alias{rdata.reader}
\alias{rds.reader}
\alias{spss.reader}
\alias{sql.reader}
\alias{stata.reader}
\alias{systat.reader}
\alias{tsv.reader}
\alias{url.reader}
\alias{wsv.reader}
\alias{xls.reader}
\alias{xlsx.reader}
\alias{xport.reader}
\title{Automatically read data into memory}
\format{
An object of class \code{list} of length 55.
}
\usage{
preinstalled.readers

arff.reader(data.file, filename, variable.name)

csv.reader(data.file, filename, variable.name)

csv2.reader(data.file, filename, variable.name)

db.reader(data.file, filename, variable.name)

dbf.reader(data.file, filename, variable.name)

epiinfo.reader(data.file, filename, variable.name)

feather.reader(data.file, filename, variable.name)

file.reader(data.file, filename, variable.name)

mp3.reader(data.file, filename, variable.name)

mtp.reader(data.file, filename, variable.name)

octave.reader(data.file, filename, variable.name)

ppm.reader(data.file, filename, variable.name)

r.reader(data.file, filename, variable.name)

rdata.reader(data.file, filename, variable.name)

rds.reader(data.file, filename, variable.name)

spss.reader(data.file, filename, variable.name)

sql.reader(data.file, filename, variable.name)

stata.reader(data.file, filename, variable.name)

systat.reader(data.file, filename, variable.name)

tsv.reader(data.file, filename, variable.name)

url.reader(data.file, filename, variable.name)

wsv.reader(data.file, filename, variable.name)

xls.reader(data.file, filename, workbook.name)

xlsx.reader(data.file, filename, workbook.name)

xport.reader(data.file, filename, variable.name)
}
\arguments{
\item{data.file}{The name of the data file to be read.}

\item{filename}{The path to the data set to be loaded.}

\item{variable.name}{The name to be assigned to in the global environment.}
}
\value{
No value is returned; the reader functions are called for its side effects.
}
\description{
The preinstalled readers are automatically loaded in the list \code{preinstalled.readers}.
The reader functions will load a data set stored in the \code{data} directory into
the specified global variable binding. These functions are not meant to be called directly.
}
\details{
Some file formats can contain more than one dataset. In this case all datasets are loaded
into separate variables in the format \code{<variable.name>.<subset.name>}, where the
\code{subset.name} is determined by the reader automatically.

The \code{sql.reader} function will load data from a SQL database based on configuration
information found in the specified .sql file. The .sql file must specify
a database to be accessed. All tables from the database, one specific tables
or one specific query against any set of tables may be executed to generate
a data set.

queries can support string interpolation to execute code snippets using mustache syntax (http://mustache.github.io). This is used
to create queries that depend on data from other sources. Code delimited is \{\{...\}\}

Example: query: SELECT * FROM my_table WHERE id IN (\{\{ids\}\}).
Here ids is a vector previously loaded into the Global Environment through ProjectTemplate

Examples of the DCF format and settings used in a .sql file are shown
below:

Example 1
type: mysql
user: sample_user
password: sample_password
host: localhost
dbname: sample_database
table: sample_table

Example 2
type: mysql
user: sample_user
password: sample_password
host: localhost
port: 3306
socket: /Applications/MAMP/tmp/mysql/mysql.sock
dbname: sample_database
table: sample_table

Example 3
type: sqlite
dbname: /path/to/sample_database
table: sample_table

Example 4
type: sqlite
dbname: /path/to/sample_database
query: SELECT * FROM users WHERE user_active == 1

Example 5
type: sqlite
dbname: /path/to/sample_database
table: *

Example 6
type: postgres
user: sample_user
password: sample_password
host: localhost
dbname: sample_database
table: sample_table

Example 7
type: odbc
dsn: sample_dsn
user: sample_user
password: sample_password
dbname: sample_database
query: SELECT * FROM sample_table

Example 8
type: oracle
user: sample_user
password: sample_password
dbname: sample_database
table: sample_table

Example 9
type: jdbc
class: oracle.jdbc.OracleDriver
classpath: /path/to/ojdbc5.jar (or set in CLASSPATH)
user: scott
password: tiger
url: jdbc:oracle:thin:@myhost:1521:orcl
query: select * from emp

Example 10
type: heroku
classpath: /path/to/jdbc4.jar (or set in CLASSPATH)
user: scott
password: tiger
host: heroku.postgres.url
port: 1234
dbname: herokudb
query: select * from emp

Example 11
In this example RSQLite::initExtension() is automatically called on the established connection.

Liam Healy has written extension-functions.c, which is available on http://www.sqlite.org/contrib.
It provides mathematical and string extension functions for SQL queries using the loadable extensions mechanism.

type: sqlite
dbname: /path/to/sample_database
plugin: extension
query: SELECT *,STDEV(value1) FROM example_table
}
\section{Functions}{
\itemize{
\item \code{arff.reader()}: Read the Weka file format from files with the \code{.arff} extension.

\item \code{csv.reader()}: Read a comma separated values file with the \code{.csv} extension.

\item \code{csv2.reader()}: Read a semicolon separated values file with the \code{.csv2} extension.

In May 2018, the default behavior of the reader for .csv2 files changed to use R's read.csv2(),
where the field separator is assumed to be ';' and the decimal separator to be ','.

\item \code{db.reader()}: Read a SQlite3 database with a \code{.db} file extension.

If you want to specify a single table or query to execute against the database,
move it elsewhere and use a .sql file interpreted by \code{\link{sql.reader}}.

\item \code{dbf.reader()}: Read an XBASE file with a \code{.dbf} file extension.

\item \code{epiinfo.reader()}: Read an Epi Info file with a .rec file extension.

\item \code{feather.reader()}: Read a feather file in Apache Arrow format with a \code{.feather} file extension.

\item \code{file.reader()}: Read an arbitrary file described in a \code{.file} file.

A \code{.file} file must contain DCF that specifies the path to the data set
and which extension should be used from the dispatch table to load the data set.

Examples of the DCF format and settings used in a .file file are shown
below:

path: http://www.johnmyleswhite.com/ProjectTemplate/sample_data.csv
extension: csv

\item \code{mp3.reader()}: Read an MP3 file with a \code{.mp3} file extension.

This function will load the specified MP3 file into memory using the
tuneR package. This is useful for working with music files as a data
set.

\item \code{mtp.reader()}: Read a Minitab Portable Worksheet with a \code{.mtp3} file extension.

\item \code{octave.reader()}: Read an Octave file with a \code{.m} file extension.

This function will load the specified Octave file into memory using the
\code{foreign::read.octave} function.

\item \code{ppm.reader()}: Read a PPM file with a \code{.ppm} file extension.

Data is loaded using the \code{pixmap::read.pnm} function.

\item \code{r.reader()}: Read an R source file with a \code{.R} file extension.

This function will call source on the specified R file, executing the
code inside of it as a way of generating data sets dynamically, as in
many Monte Carlo applications.

\item \code{rdata.reader()}: Read an RData file with a \code{.rdata} or \code{.rda} file extension.

This function will load the specified RData file into memory using the
\code{\link{load}} function. This may generate many data sets
simultaneously.

\item \code{rds.reader()}: Read the RDS file format from files with the \code{.rds} extension.

\item \code{spss.reader()}: Read an SPSS file with a \code{.sav} file extension.

This function will load the specified SPSS file into memory. It will
convert the resulting list object into a data frame before inserting the
data set into the global environment.

\item \code{sql.reader()}: Read a database described in a \code{.sql} file.

\item \code{stata.reader()}: Read a Stata file with a \code{.stata} file extension.

\item \code{systat.reader()}: Read a Systat file with a \code{.sys} or \code{.syd} file extension.

\item \code{tsv.reader()}: Read a tab separated values file with the \code{.tsv} or \code{.tab} file extensions.

\item \code{url.reader()}: Read a remote file described in a \code{.url} file.

This function will load data from a remote source accessible through
HTTP or FTP based on configuration information found in the specified
.url file. The \code{.url} file must specify the URL of the remote data source
and the type of data that is available remotely. Only one data source
per \code{.url} file is supported currently.

Examples of the DCF format and settings used in a .url file are shown
below:

Example 1
url: http://www.johnmyleswhite.com/ProjectTemplate/sample_data.csv
separator: ,

\item \code{wsv.reader()}: Read a whitespace separated values file with the \code{.wsv} or \code{.txt} file extensions.

\item \code{xls.reader()}: Read an Excel file with a \code{.xls} file extension.

This function will load the specified Excel file into memory using the
\code{readxl} package.

\item \code{xlsx.reader()}: Read an Excel 2007 file with a \code{.xlsx} file extension.

This function will load the specified Excel file into memory using the
\code{readxl} package.

\item \code{xport.reader()}: Read an XPort file with a \code{.xport} file extension.

}}
\seealso{
\link{.add.extension}
}
\keyword{datasets}
\keyword{internal}
