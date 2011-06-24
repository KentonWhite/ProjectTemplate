stata.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.dta(filename),
         envir = .GlobalEnv)
}
