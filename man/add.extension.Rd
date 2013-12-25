\name{add.extension}
\alias{add.extension}
\title{Associate a reader function with an extension.}
\usage{
add.extension(extension, reader)
}
\arguments{
  \item{extension}{The extension of the new data file.}

  \item{reader}{The function to user when reading the data
  file.}
}
\value{
No value is returned; this function is called for its side effects.
}
\description{
This function will associate an extension with a custom reader function.
}
\examples{
\dontrun{add.extension('foo', foo.reader)}
}

