#' Automatically read data into memory
#'
#' The preinstalled readers are automatically loaded in the list \code{preinstalled.readers}.
#' The reader functions will load a data set stored in the \code{data} directory into
#' the specified global variable binding. These functions are not meant to be called directly.
#'
#' Some file formats can contain more than one dataset. In this case all datasets are loaded
#' into separate variables in the format \code{<variable.name>.<subset.name>}, where the
#' \code{subset.name} is determined by the reader automatically.
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#'
#' @seealso \link{.add.extension}
#' @keywords internal datasets
#'
#' @return No value is returned; the reader functions are called for its side effects.
preinstalled.readers <-
list("*.csv" = "csv.reader",
     "*.csv.bz2" = "csv.reader",
     "*.csv.zip" = "csv.reader",
     "*.csv.gz" = "csv.reader",
     "*.csv2" = "csv2.reader",
     "*.csv2.bz2" = "csv2.reader",
     "*.csv2.zip" = "csv2.reader",
     "*.csv2.gz" = "csv2.reader",
     "*.tsv" = "tsv.reader",
     "*.tsv.bz2" = "tsv.reader",
     "*.tsv.zip" = "tsv.reader",
     "*.tsv.gz" = "tsv.reader",
     "*.tab" = "tsv.reader",
     "*.tab.bz2" = "tsv.reader",
     "*.tab.zip" = "tsv.reader",
     "*.tab.gz" = "tsv.reader",
     "*.wsv" = "wsv.reader",
     "*.wsv.bz2" = "wsv.reader",
     "*.wsv.zip" = "wsv.reader",
     "*.wsv.gz" = "wsv.reader",
     "*.txt" = "wsv.reader",
     "*.txt.bz2" = "wsv.reader",
     "*.txt.zip" = "wsv.reader",
     "*.txt.gz" = "wsv.reader",
     "*.RData" = "rdata.reader",
     "*.Rdata" = "rdata.reader",
     "*.rda" = "rdata.reader",
     "*.rds" = "rds.reader",
     "*.R" = "r.reader",
     "*.r" = "r.reader",
     "*.url" = "url.reader",
     "*.sql" = "sql.reader",
     "*.xls" = "xls.reader",
     "*.xlsx" = "xlsx.reader",
     "*.sav" = "spss.reader",
     "*.dta" = "stata.reader",
     "*.arff" = "arff.reader",
     "*.dbf" = "dbf.reader",
     "*.rec" = "epiinfo.reader",
     "*.mtp" = "mtp.reader",
     "*.m" = "octave.reader",
     "*.sys" = "systat.reader",
     "*.syd" = "systat.reader",
     "*.sas" = "xport.reader",
     "*.xport" = "xport.reader",
     "*.xpt" = "xport.reader",
     "*.db" = "db.reader",
     "*.file" = "file.reader",
     "*.mp3" = "mp3.reader",
     "*.ppm" = "ppm.reader",
     "*.dat" = "wsv.reader",
     "*.dat.bz2" = "wsv.reader",
     "*.dat.zip" = "wsv.reader",
     "*.dat.gz" = "wsv.reader",
     "*.feather" = "feather.reader"
)

extensions.dispatch.table <- new.env()

for(extension in names(preinstalled.readers)) {
  extensions.dispatch.table[[glob2rx(extension, trim.head=TRUE)]] <- eval(preinstalled.readers[[extension]])
}

.TargetEnv <- .GlobalEnv
