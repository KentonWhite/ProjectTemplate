\name{translate.dcf}
\alias{translate.dcf}
\title{
Read a DCF file into a list object.
}
\description{
\code{translate.dcf()} produces a list that contains all the values from a DCF file.
}
\usage{
translate.dcf(filename)
}
\arguments{
  \item{filename}{
	A character vector specifying the DCF file to be translated.
}
}
\value{
	Returns a list containing the entries from the DCF file.
}
\examples{
\dontrun{
library('ProjectTemplate')

translate.dcf(file.path('config', 'global.dcf'))}}

