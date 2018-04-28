#' @describeIn preinstalled.readers Read a remote file described in a \code{.url} file.
#'
#' This function will load data from a remote source accessible through
#' HTTP or FTP based on configuration information found in the specified
#' .url file. The \code{.url} file must specify the URL of the remote data source
#' and the type of data that is available remotely. Only one data source
#' per \code{.url} file is supported currently.
#'
#' Examples of the DCF format and settings used in a .url file are shown
#' below:
#'
#' Example 1
#' url: http://www.johnmyleswhite.com/ProjectTemplate/sample_data.csv
#' separator: ,
#' @importFrom utils download.file
url.reader <- function(data.file, filename, variable.name)
{
  url.info <- translate.dcf(filename)

  file.type <- ""

  for (extension in ls(extensions.dispatch.table))
  {
    if(grepl(extension, url.info[['url']], ignore.case = TRUE, perl = TRUE))
    {
      file.type <- extension
    }
  }

  if (file.type == "")
  {
    warning(paste("The source at",
                  url.info[['url']],
                  "was not processed properly."))
  }
  else
  {
    if (file.type %in% c("\\.Rdata$", "\\.Rda$"))
    {
      con <- url(url.info[['url']])
      rdata.reader(data.file, con, variable.name)
    }

    if (file.type %in% c("\\.xlsx$"))
    {
      download.file(url.info[['url']], file.path(tempdir(), "xlsxtmp.xlsx"))
      xlsx.reader(data.file, file.path(tempdir(), "xlsxtmp.xlsx"), variable.name)
    }

    if (file.type %in% c("\\.sql$"))
    {
      download.file(url.info[['url']], file.path(tempdir(), "sqltmp.sql"))
      sql.reader(data.file, file.path(tempdir(), "sqltmp.sql"), variable.name)
    }

    else
    {
      do.call(extensions.dispatch.table[[file.type]],
              list(data.file,
                   url.info[['url']],
                   variable.name))
    }
  }
}
