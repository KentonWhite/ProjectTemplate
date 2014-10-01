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
#' \dontrun{xlsx.reader('example.xlsx', 'data/example.xlsx', 'example')}
xlsx.reader <- function(data.file, filename, workbook.name)
{
  .require.package('xlsx')

  wb <- xlsx::loadWorkbook(filename)
  sheets <- xlsx::getSheets(wb)

  for (sheet.name in names(sheets))
  {
    variable.name <- paste(workbook.name, clean.variable.name(sheet.name), sep = ".")
    tryCatch(assign(variable.name,
                    xlsx::read.xlsx(filename,
                              sheetName = sheet.name,
                              header = TRUE),
                    envir = .TargetEnv),
             error = function(e)
             {
               warning(paste("The worksheet", sheet.name, "didn't load correctly."))
             })
  }
}
