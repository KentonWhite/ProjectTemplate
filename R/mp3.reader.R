mp3.reader <- function(data.file, filename, variable.name)
{
  library('tuneR')
  
  assign(variable.name,
         readMP3(filename),
         envir = .GlobalEnv)
}
