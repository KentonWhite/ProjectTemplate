octave.reader <- function(data.file, filename, variable.name)
{
  library('foreign')

  assign(variable.name,
         read.octave(filename),
         envir = .GlobalEnv)
}
