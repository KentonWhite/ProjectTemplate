wsv.reader <- function(data.file, filename, variable.name)
{
  assign(variable.name,
         read.csv(filename,
                  header = TRUE,
                  sep = ' '),
         envir = .GlobalEnv)
}
