xls.reader <- function(data.file, filename, workbook.name)
{
  library('gdata')
  sheets <- sheetNames(filename)
  
  for (sheet.name in sheets)
  {
    variable.name <- paste(workbook.name, ProjectTemplate:::clean.variable.name(sheet.name), sep = ".")
    tryCatch(assign(variable.name,
                    read.xls(filename,
                             sheet = sheet.name),
                    envir = .GlobalEnv),
             error = function(e)
             {
               warning(paste("The worksheet", sheet.name, "didn't load correctly."))
             })
  }
}
