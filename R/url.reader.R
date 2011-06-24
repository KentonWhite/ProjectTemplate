url.reader <- function(data.file, filename, variable.name)
{
  # A .url file contains YAML describing the data source.
  # Only one data source per file is supported.
  # An example file is shown below.
  #
  # url: http://www.johnmyleswhite.com/ProjectTemplate/sample_data.csv
  # separator: ,

  extensions.dispatch.table <- list("\\.csv$" = ProjectTemplate:::csv.reader,
                                    "\\.csv.bz2$" = ProjectTemplate:::csv.reader,
                                    "\\.csv.zip$" = ProjectTemplate:::csv.reader,
                                    "\\.csv.gz$" = ProjectTemplate:::csv.reader,
                                    "\\.tsv$" = ProjectTemplate:::tsv.reader,
                                    "\\.tsv.bz2$" = ProjectTemplate:::tsv.reader,
                                    "\\.tsv.zip$" = ProjectTemplate:::tsv.reader,
                                    "\\.tsv.gz$" = ProjectTemplate:::tsv.reader,
                                    "\\.wsv$" = ProjectTemplate:::wsv.reader,
                                    "\\.wsv.bz2$" = ProjectTemplate:::wsv.reader,
                                    "\\.wsv.zip$" = ProjectTemplate:::wsv.reader,
                                    "\\.wsv.gz$" = ProjectTemplate:::wsv.reader,
                                    "\\.Rdata$" = ProjectTemplate:::rdata.reader,
                                    "\\.rda$" = ProjectTemplate:::rdata.reader,
                                    "\\.url$" = ProjectTemplate:::url.reader,
                                    "\\.sql$" = ProjectTemplate:::sql.reader,
                                    "\\.xls$" = ProjectTemplate:::xls.reader,
                                    "\\.xlsx$" = ProjectTemplate:::xlsx.reader,
                                    "\\.sav$" = ProjectTemplate:::spss.reader,
                                    "\\.dta$" = ProjectTemplate:::stata.reader)

  url.info <- ProjectTemplate:::translate.dcf(filename)

  file.type <- ""
  
  for (extension in names(ProjectTemplate:::extensions.dispatch.table))
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
      ProjectTemplate:::rdata.reader(data.file, con, variable.name)
    }

    if (file.type %in% c("\\.xlsx$"))
    {
      download.file(url.info[['url']], file.path(tempdir(), "xlsxtmp.xlsx"))
      ProjectTemplate:::xlsx.reader(data.file, file.path(tempdir(), "xlsxtmp.xlsx"), variable.name)
    }

    if (file.type %in% c("\\.sql$"))
    {
      download.file(url.info[['url']], file.path(tempdir(), "sqltmp.sql"))
      ProjectTemplate:::sql.reader(data.file, file.path(tempdir(), "sqltmp.sql"), variable.name)
    }
    
    else
    {
      do.call(ProjectTemplate:::extensions.dispatch.table[[file.type]],
              list(data.file,
                   url.info[['url']],
                   variable.name))
    }
  }
}
