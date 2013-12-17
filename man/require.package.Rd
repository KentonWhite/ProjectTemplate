\name{require.package}
\alias{require.package}
\title{Require a package for use in the project}
\usage{
require.package(package.name)
}
\value{
No value is returned; this function is called for its side effects.
}
\description{
This function will require the given package. If the package is not installed
it will stop execution and print a message to the user instructing them which
package to install and which function caused the error.
}
\examples{
library('ProjectTemplate')

\dontrun{require.project('PackageName')}
}

