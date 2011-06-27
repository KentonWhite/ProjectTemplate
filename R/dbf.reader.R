dbf.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.dbf(filename),
         envir = .GlobalEnv)
}
