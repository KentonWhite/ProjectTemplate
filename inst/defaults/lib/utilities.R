clean.variable.name <- function(variable.name)
{
  variable.name <- gsub('^[^a-zA-Z0-9]+', '', variable.name, perl = TRUE)
  variable.name <- gsub('[^a-zA-Z0-9]+$', '', variable.name, perl = TRUE)
  variable.name <- gsub('_+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('-+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\s+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\.+', '.', variable.name, perl = TRUE)
  variable.name <- make.names(variable.name)
  return(variable.name)
}

cache.name <- function(data.filename)
{
  return(gsub('\\..*', '', data.filename, perl = TRUE))
}
