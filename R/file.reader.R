file.reader <- function(data.file, filename, variable.name)
{
  # A .file file contains DCF describing the data source.
  # Only one data source per file is supported.
  # An example file is shown below.
  #
  # path: http://www.johnmyleswhite.com/ProjectTemplate/sample_data.csv
  # extension: ,

  file.info <- ProjectTemplate:::translate.dcf(filename)
  file.type <- paste('\\.', file.info[['extension']], '$', sep = '')

  do.call(ProjectTemplate:::extensions.dispatch.table[[file.type]],
          list(data.file,
               file.info[['path']],
               variable.name))
}
