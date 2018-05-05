#' @describeIn preinstalled.readers Read an Excel file with a \code{.xls} file
#'   extension.
#'
#' This function will load the specified Excel file into memory using the
#' \code{readxl} package.
#'
#' @include add.extension.R
xls.reader <- function(filename, variable.name, ...) {
  .require.package('readxl')

  sheets <- readxl::excel_sheets(filename)

  for (sheet.name in sheets) {
    variable.name <- paste(variable.name, clean.variable.name(sheet.name), sep = ".", ...)
    tryCatch(assign(variable.name,
                    data.frame(readxl::read_excel(filename,
                                                  sheet = sheet.name)),
                    envir = .TargetEnv),
             error = function(e) {
               warning(paste("The worksheet", sheet.name, "didn't load correctly."))
             }
    )
  }
}

.add.extension('xls', xls.reader)
.add.extension('xlsx', xls.reader)
