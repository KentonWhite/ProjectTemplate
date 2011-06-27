systat.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.systat(filename),
         envir = .GlobalEnv)
}
