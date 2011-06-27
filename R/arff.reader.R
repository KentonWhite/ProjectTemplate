arff.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.arff(filename),
         envir = .GlobalEnv)
}
