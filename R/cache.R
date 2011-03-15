cache <- function(variable)
{
  save(variable, file = file.path('cache', variable))
}
