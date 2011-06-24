cache <- function(variable)
{
  save(variable,
       list = variable,
       file = file.path('cache',
                        paste(variable, '.RData', sep = '')))
}
