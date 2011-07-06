\name{clean.variable.name}
\alias{clean.variable.name}
\title{Translate a file name into a valid R variable name.}
\usage{clean.variable.name(variable.name)}

\description{
  Translate a file name into a valid R variable name.
}

\details{
  This function will translate a file name into a name that
  is a valid variable name in R. Non-alphabetic characters
  on the boundaries of the file name will be stripped;
  non-alphabetic characters inside of the file name will be
  replaced with dots.
}
\value{A translated variable name.}
\arguments{
  \item{variable.name}{A character vector containing a variable's proposed
name that should be standardized.}
}
\examples{library('ProjectTemplate')

#clean.variable.name('example_1')}
