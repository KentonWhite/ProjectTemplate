xport.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.xport(filename),
         envir = .GlobalEnv)
}
