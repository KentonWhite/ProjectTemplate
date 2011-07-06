\name{cache}
\alias{cache}
\title{Cache a data set for faster loading.}
\usage{cache(variable)}

\description{
  Cache a data set for faster loading.
}

\details{
  This function will store a copy of the named data set in
  the \code{cache} directory. This cached copy of the data
  set will then be given precedence at load time when
  calling \code{\link{load.project}}. Cached data sets are
  stored as \code{.RData} files.
}
\value{No value is returned; this function is called for its side effects.}
\arguments{
  \item{variable}{A character vector containing the name of the variable to 
be saved.}
}
\examples{library('ProjectTemplate')
#create.project('tmp-project')

#setwd('tmp-project')

#dataset1 <- 1:5
#cache('dataset1')

#setwd('..')
#unlink('tmp-project')}
