xlsx.reader <- function(data.file, filename, workbook.name)
{
  library('xlsx')
  
  wb <- loadWorkbook(filename)
  sheets <- getSheets(wb)

  for (sheet.name in names(sheets))
  {
    variable.name <- paste(workbook.name, ProjectTemplate:::clean.variable.name(sheet.name), sep = ".")
    tryCatch(assign(variable.name,
                    read.xlsx(filename,
                              sheetName = sheet.name,
                              header = TRUE),
                    envir = .GlobalEnv),
             error = function(e)
             {
               warning(paste("The worksheet", sheet.name, "didn't load correctly."))
             })
  }
}
