\name{cache}
\alias{cache}
\title{
Cache a variable for later use.
}
\description{
\code{cache()} stores a variable in the cache/ directory as an .RData file.
}
\usage{
cache(variable)
}
\arguments{
  \item{variable}{
	A character vector containing the name of the variable to be saved.
}
}
\value{
	No value is returned; this function is called for its side effects.
}
\examples{
\dontrun{
library('ProjectTemplate')

var1 <- 1:5

cache('var1')}}
