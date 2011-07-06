\name{cache.name}
\alias{cache.name}
\title{Translate a variable name into a file name for caching.}
\usage{cache.name(data.filename)}

\description{
  Translate a variable name into a file name for caching.
}

\details{
  This function will translate a variable name into a form
  that is suitable as a filename on most OS's.
}
\value{A translated variable name.}
\arguments{
  \item{data.filename}{The variable name to be translated into a filename.}
}
\examples{library('ProjectTemplate')

#cache.name('example.1')}
