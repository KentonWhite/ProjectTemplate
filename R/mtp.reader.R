mtp.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.mtp(filename),
         envir = .GlobalEnv)
}
