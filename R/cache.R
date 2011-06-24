cache <- function(variable)
{
  save(get(variable), file = file.path('cache', paste(variable, '.RData', sep = '')))
}
