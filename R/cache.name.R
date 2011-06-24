cache.name <- function(data.filename)
{
  return(gsub('\\..*', '', data.filename, perl = TRUE))
}
