\name{clean.variable.name}
\alias{clean.variable.name}
\title{
Produce a standardized R variable names.
}
\description{
\code{clean.variable.name()} produces a valid R variable that satisfies ProjectTemplate conventions.
}
\usage{
clean.variable.name(variable.name)
}
\arguments{
  \item{variable.name}{
	A character vector containing a variable's proposed name that should be standardized.
}
}
\value{
	Returns a character vector containing the standardized variable name.
}
\examples{
\dontrun{
library('ProjectTemplate')

clean.variable.name('project_name')}}
