epiinfo.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.epiinfo(filename),
         envir = .GlobalEnv)
}
