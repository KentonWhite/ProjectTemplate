translate.dcf <- function(filename)
{
  settings <- read.dcf(filename)

  tmp <- list()

  for (name in colnames(settings))
  {
    tmp[[name]] <- as.character(settings[1, name])
  }

  return(tmp)
}
