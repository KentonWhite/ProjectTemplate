spss.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  #assign(variable.name,
  #       read.spss(filename),
  #       envir = .GlobalEnv)

  assign(variable.name,
         as.data.frame(read.spss(filename)),
         envir = .GlobalEnv)
}
