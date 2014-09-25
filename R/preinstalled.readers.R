#' Maps file types to the reader functions used to autoload them.
#'
#' This list stores a mapping from regular expressions that match file
#' extensions for the file types supported by ProjectTemplate to the
#' reader functions that implement autoloading for those formats. Any
#' new file type must be appended to this dispatch table.
#'
#' @include arff.reader.R
#' @include csv.reader.R
#' @include csv2.reader.R
#' @include db.reader.R
#' @include dbf.reader.R
#' @include epiinfo.reader.R
#' @include file.reader.R
#' @include mp3.reader.R
#' @include mtp.reader.R
#' @include octave.reader.R
#' @include ppm.reader.R
#' @include r.reader.R
#' @include rdata.reader.R
#' @include spss.reader.R
#' @include sql.reader.R
#' @include stata.reader.R
#' @include systat.reader.R
#' @include tsv.reader.R
#' @include url.reader.R
#' @include wsv.reader.R
#' @include xls.reader.R
#' @include xlsx.reader.R
#' @include xport.reader.R

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
     "*.Rdata" = "rdata.reader",
     "*.rda" = "rdata.reader",
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
     "*.dat.gz" = "wsv.reader"
)

extensions.dispatch.table <- new.env()

for(extension in names(preinstalled.readers)) {
  extensions.dispatch.table[[glob2rx(extension, trim.head=TRUE)]] <- eval(preinstalled.readers[[extension]])
}

.TargetEnv <- .GlobalEnv
