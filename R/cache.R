cache <- function(variable)
{
  save(list = variable,
       envir = .GlobalEnv,
       file = file.path('cache',
                        paste(variable, '.RData', sep = '')))
}
