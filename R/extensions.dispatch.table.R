#' Maps file types to the reader functions used to autoload them.
#'
#' This list stores a mapping from regular expressions that match file
#' extensions for the file types supported by ProjectTemplate to the
#' reader functions that implement autoloading for those formats. Any
#' new file type must be appended to this dispatch table.
#'
#' @include R/arff.reader.R
#' @include R/csv.reader.R
#' @include R/db.reader.R
#' @include R/dbf.reader.R
#' @include R/epiinfo.reader.R
#' @include R/file.reader.R
#' @include R/mp3.reader.R
#' @include R/mtp.reader.R
#' @include R/octave.reader.R
#' @include R/ppm.reader.R
#' @include R/r.reader.R
#' @include R/rdata.reader.R
#' @include R/spss.reader.R
#' @include R/sql.reader.R
#' @include R/stata.reader.R
#' @include R/systat.reader.R
#' @include R/tsv.reader.R
#' @include R/url.reader.R
#' @include R/wsv.reader.R
#' @include R/xls.reader.R
#' @include R/xlsx.reader.R
#' @include R/xport.reader.R
extensions.dispatch.table <- list("\\.csv$" = ProjectTemplate:::csv.reader,
                                  "\\.csv.bz2$" = ProjectTemplate:::csv.reader,
                                  "\\.csv.zip$" = ProjectTemplate:::csv.reader,
                                  "\\.csv.gz$" = ProjectTemplate:::csv.reader,
                                  "\\.tsv$" = ProjectTemplate:::tsv.reader,
                                  "\\.tsv.bz2$" = ProjectTemplate:::tsv.reader,
                                  "\\.tsv.zip$" = ProjectTemplate:::tsv.reader,
                                  "\\.tsv.gz$" = ProjectTemplate:::tsv.reader,
                                  "\\.tab$" = ProjectTemplate:::tsv.reader,
                                  "\\.tab.bz2$" = ProjectTemplate:::tsv.reader,
                                  "\\.tab.zip$" = ProjectTemplate:::tsv.reader,
                                  "\\.tab.gz$" = ProjectTemplate:::tsv.reader,
                                  "\\.wsv$" = ProjectTemplate:::wsv.reader,
                                  "\\.wsv.bz2$" = ProjectTemplate:::wsv.reader,
                                  "\\.wsv.zip$" = ProjectTemplate:::wsv.reader,
                                  "\\.wsv.gz$" = ProjectTemplate:::wsv.reader,
                                  "\\.txt$" = ProjectTemplate:::wsv.reader,
                                  "\\.txt.bz2$" = ProjectTemplate:::wsv.reader,
                                  "\\.txt.zip$" = ProjectTemplate:::wsv.reader,
                                  "\\.txt.gz$" = ProjectTemplate:::wsv.reader,
                                  "\\.Rdata$" = ProjectTemplate:::rdata.reader,
                                  "\\.rda$" = ProjectTemplate:::rdata.reader,
                                  "\\.R$" = ProjectTemplate:::r.reader,
                                  "\\.r$" = ProjectTemplate:::r.reader,
                                  "\\.url$" = ProjectTemplate:::url.reader,
                                  "\\.sql$" = ProjectTemplate:::sql.reader,
                                  "\\.xls$" = ProjectTemplate:::xls.reader,
                                  "\\.xlsx$" = ProjectTemplate:::xlsx.reader,
                                  "\\.sav$" = ProjectTemplate:::spss.reader,
                                  "\\.dta$" = ProjectTemplate:::stata.reader,
                                  "\\.arff$" = ProjectTemplate:::arff.reader,
                                  "\\.dbf$" = ProjectTemplate:::dbf.reader,
                                  "\\.rec$" = ProjectTemplate:::epiinfo.reader,
                                  "\\.mtp$" = ProjectTemplate:::mtp.reader,
                                  "\\.m$" = ProjectTemplate:::octave.reader,
                                  "\\.sys$" = ProjectTemplate:::systat.reader,
                                  "\\.syd$" = ProjectTemplate:::systat.reader,
                                  "\\.sas$" = ProjectTemplate:::xport.reader,
                                  "\\.xport$" = ProjectTemplate:::xport.reader,
                                  "\\.db$" = ProjectTemplate:::db.reader,
                                  "\\.file$" = ProjectTemplate:::file.reader,
                                  "\\.mp3$" = ProjectTemplate:::mp3.reader,
                                  "\\.ppm$" = ProjectTemplate:::ppm.reader,
                                  "\\.xpt$" = ProjectTemplate:::xport.reader,
                                  "\\.dat$" = ProjectTemplate:::wsv.reader,
                                  "\\.dat.bz2$" = ProjectTemplate:::wsv.reader,
                                  "\\.dat.zip$" = ProjectTemplate:::wsv.reader,
                                  "\\.dat.gz$" = ProjectTemplate:::wsv.reader)
                                  
