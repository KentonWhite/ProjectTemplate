foo.reader <- function(data.file, filename, variable.name)
{
  assign(variable.name,
         "bar",
         envir = .GlobalEnv)
  return()
	
}

ProjectTemplate:::add.extension('foo', foo.reader)