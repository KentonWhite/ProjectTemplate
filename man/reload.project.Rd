\name{reload.project}
\alias{reload.project}
\title{Reload a project from scratch.}
\value{
  No value is returned; this function is called for its
  side effects.
}
\description{
  This function will clear the global environment and
  reload a project from scratch. This is useful when you've
  updated your data sets or changed your preprocessing
  scripts.
}
\examples{
library('ProjectTemplate')

\dontrun{load.project()

reload.project()}
}

