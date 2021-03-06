% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load.project.R
\name{.convert.to.tibble}
\alias{.convert.to.tibble}
\title{Convert one or more data sets to tibbles}
\usage{
.convert.to.tibble(data.sets)
}
\arguments{
\item{data.sets}{A character vector of variable names.}
}
\value{
No value is returned; this function is called for its side effects.
}
\description{
Converts all \code{base::data.frame}s referred to in the input to
\code{tibble}s. The resulting data set is stored in the
\code{.TargetEnv}.
}
\keyword{internal}
