#' Read a whitespace separated values (.wsv or .txt) file.
#'
#' This function will load a data set stored in the WSV file format into
#' the specified global variable binding.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' wsv.reader('example.wsv', 'data/example.wsv', 'example')
wsv.reader <- function(data.file, filename, variable.name)
{
  if (grepl('\\.zip$', filename))
  {
    tmp.dir <- tempdir()
    tmp.path <- file.path(tmp.dir, data.file)
    file.copy(filename, tmp.path)
    unzip(filename, exdir = tmp.dir)
    filename <- file.path(tmp.dir, sub('\\.zip$', '', data.file))
  }
  
  assign(variable.name,
         read.csv(filename,
                  header = TRUE,
                  sep = ' '),
         envir = .GlobalEnv)
}
