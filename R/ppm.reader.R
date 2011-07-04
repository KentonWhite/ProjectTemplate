ppm.reader <- function(data.file, filename, variable.name)
{
  library('pixmap')

  assign(variable.name,
         read.pnm(filename),
         envir = .GlobalEnv)
}

