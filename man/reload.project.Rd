\name{reload.project}
\alias{reload.project}
\title{
Reload the current project.
}
\description{
\code{reload.project()} clears the global environment and then calls load.project(), which runs .
}
\usage{
reload.project()
}
\value{
	No value is returned; this function is called for its side effects.
}
\examples{
\dontrun{
library('ProjectTemplate')
load.project()

reload.project()}}
