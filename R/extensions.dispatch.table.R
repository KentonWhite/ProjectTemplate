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
extensions.dispatch.table <- list("\\.csv$" = ProjectTemplate:::csv.reader,
                                  "\\.csv.bz2$" = ProjectTemplate:::csv.reader,
                                  "\\.csv.zip$" = ProjectTemplate:::csv.reader,
                                  "\\.csv.gz$" = ProjectTemplate:::csv.reader,
                                  "\\.csv2$" = ProjectTemplate:::csv2.reader,
                                  "\\.csv2.bz2$" = ProjectTemplate:::csv2.reader,
                                  "\\.csv2.zip$" = ProjectTemplate:::csv2.reader,
                                  "\\.csv2.gz$" = ProjectTemplate:::csv2.reader,
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
                                  "\\.xpt$" = ProjectTemplate:::xport.reader,
                                  "\\.db$" = ProjectTemplate:::db.reader,
                                  "\\.file$" = ProjectTemplate:::file.reader,
                                  "\\.mp3$" = ProjectTemplate:::mp3.reader,
                                  "\\.ppm$" = ProjectTemplate:::ppm.reader,
                                  "\\.dat$" = ProjectTemplate:::wsv.reader,
                                  "\\.dat.bz2$" = ProjectTemplate:::wsv.reader,
                                  "\\.dat.zip$" = ProjectTemplate:::wsv.reader,
                                  "\\.dat.gz$" = ProjectTemplate:::wsv.reader)
                                  
