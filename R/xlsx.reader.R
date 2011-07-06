#' Read an Excel 2007 file with a .xlsx file extension.
#'
#' This function will load the specified Excel file into memory using the
#' xlsx package. Each sheet of the Excel workbook will be read into a
#' separate variable in the global environment.
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param workbook.name The name to be assigned to in the global environment.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' #xlsx.reader('example.xlsx', 'data/example.xlsx', 'example')
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
