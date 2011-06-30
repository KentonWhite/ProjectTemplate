library('testthat')

library('ProjectTemplate')

# Example 01: CSV Data File
print('Example 01: Testing .csv support')
data.file <- 'example_01'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_01.csv')
variable.name <- ProjectTemplate:::clean.variable.name('example_01')

ProjectTemplate:::csv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.01)

# Example 02: CSV Data File with BZip2 Compression
print('Example 02: Testing .csv.bz2 support')
data.file <- 'example_02'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_02.csv.bz2')
variable.name <- ProjectTemplate:::clean.variable.name('example_02')

ProjectTemplate:::csv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.02)

# Example 03: CSV Data File with Zip Compression
#print('Example 03: Testing .csv.zip support')
#data.file <- 'example_03'
#filename <- file.path(system.file('example_data',
#                                  package = 'ProjectTemplate'),
#                      'example_03.csv.zip')
#variable.name <- ProjectTemplate:::clean.variable.name('example_03')
#
#ProjectTemplate:::csv.reader(data.file, filename, variable.name)
#
#expect_that(exists(variable.name), is_true())
#expect_that(nrow(get(variable.name)), equals(5))
#expect_that(ncol(get(variable.name)), equals(2))
#expect_that(get(variable.name)[5, 2], equals(11))
#rm(example.03)

# Example 04: CSV Data File with GZip Compression
print('Example 04: Testing .csv.gz support')
data.file <- 'example_04'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_04.csv.gz')
variable.name <- ProjectTemplate:::clean.variable.name('example_04')

ProjectTemplate:::csv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.04)

# Example 05: TSV Data File
print('Example 05: Testing .tsv support')
data.file <- 'example_05'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_05.tsv')
variable.name <- ProjectTemplate:::clean.variable.name('example_05')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.05)

# Example 06: TSV Data File with BZip2 Compression
print('Example 06: Testing .tsv.bz2 support')
data.file <- 'example_06'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_06.tsv.bz2')
variable.name <- ProjectTemplate:::clean.variable.name('example_06')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.06)

# Example 07: TSV Data File with Zip Compression
#print('Example 07: Testing .tsv.zip support')
#data.file <- 'example_07'
#filename <- file.path(system.file('example_data',
#                                  package = 'ProjectTemplate'),
#                      'example_07.tsv.zip')
#variable.name <- ProjectTemplate:::clean.variable.name('example_07')
#
#ProjectTemplate:::tsv.reader(data.file, filename, variable.name)
#
#expect_that(exists(variable.name), is_true())
#expect_that(nrow(get(variable.name)), equals(5))
#expect_that(ncol(get(variable.name)), equals(2))
#expect_that(get(variable.name)[5, 2], equals(11))
#rm(example.07)

# Example 08: TSV Data File with GZip Compression
print('Example 08: Testing .tsv.gz support')
data.file <- 'example_08'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_08.tsv.gz')
variable.name <- ProjectTemplate:::clean.variable.name('example_08')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.08)

# Example 09: WSV Data File
print('Example 09: Testing .wsv support')
data.file <- 'example_09'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_09.wsv')
variable.name <- ProjectTemplate:::clean.variable.name('example_09')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.09)

# Example 10: WSV Data File with BZip2 Compression
print('Example 10: Testing .wsv.bz2 support')
data.file <- 'example_10'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_10.wsv.bz2')
variable.name <- ProjectTemplate:::clean.variable.name('example_10')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.10)

# Example 11: WSV Data File with Zip Compression
#print('Example 11: Testing .wsv.zip support')
#data.file <- 'example_11'
#filename <- file.path(system.file('example_data',
#                                  package = 'ProjectTemplate'),
#                      'example_11.wsv.zip')
#variable.name <- ProjectTemplate:::clean.variable.name('example_11')
#
#ProjectTemplate:::wsv.reader(data.file, filename, variable.name)
#
#expect_that(exists(variable.name), is_true())
#expect_that(nrow(get(variable.name)), equals(5))
#expect_that(ncol(get(variable.name)), equals(2))
#expect_that(get(variable.name)[5, 2], equals(11))
#rm(example.11)

# Example 12: WSV Data File with GZip Compression
print('Example 12: Testing .wsv.gz support')
data.file <- 'example_12'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_12.wsv.gz')
variable.name <- ProjectTemplate:::clean.variable.name('example_12')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.12)

# Example 13: RData Data File with .RData Extension
print('Example 13: Testing .Rdata support')
data.file <- 'example_13'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_13.RData')
variable.name <- ProjectTemplate:::clean.variable.name('example_13')

ProjectTemplate:::rdata.reader(data.file, filename, variable.name)

expect_that(exists('m'), is_true())
expect_that(nrow(get('m')), equals(5))
expect_that(ncol(get('m')), equals(2))
expect_that(get('m')[5, 2], equals(11))
rm('m')

# Example 14: RData Data File with .rda Extension
print('Example 14: Testing .rda support')
data.file <- 'example_14'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_14.rda')
variable.name <- ProjectTemplate:::clean.variable.name('example_14')

ProjectTemplate:::rdata.reader(data.file, filename, variable.name)

expect_that(exists('n'), is_true())
expect_that(nrow(get('n')), equals(5))
expect_that(ncol(get('n')), equals(2))
expect_that(get('n')[5, 2], equals(11))
rm('n')

# Example 15: URL File with .url Extension

# Example 16: TSV File with .tab Extension
print('Example 16: Testing .tab support')
data.file <- 'example_16'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_16.tab')
variable.name <- ProjectTemplate:::clean.variable.name('example_16')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.16)

# Example 17: TSV File with .tab Extension and BZip2 Compression
print('Example 17: Testing .tab.bz2 support')
data.file <- 'example_17'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_17.tab.bz2')
variable.name <- ProjectTemplate:::clean.variable.name('example_17')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.17)

# Example 18: TSV File with .tab Extension and Zip Compression
#print('Example 18: Testing .tab.zip support')
#data.file <- 'example_18'
#filename <- file.path(system.file('example_data',
#                                  package = 'ProjectTemplate'),
#                      'example_18.tab.zip')
#variable.name <- ProjectTemplate:::clean.variable.name('example_18')
#
#ProjectTemplate:::tsv.reader(data.file, filename, variable.name)
#
#expect_that(exists(variable.name), is_true())
#expect_that(nrow(get(variable.name)), equals(5))
#expect_that(ncol(get(variable.name)), equals(2))
#expect_that(get(variable.name)[5, 2], equals(11))
#rm(example.18)

# Example 19: TSV File with .tab Extension and GZip Compression
print('Example 19: Testing .tab.gz support')
data.file <- 'example_19'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_19.tab.gz')
variable.name <- ProjectTemplate:::clean.variable.name('example_19')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.19)

# Example 20: WSV File with .txt Extension
print('Example 20: Testing .txt support')
data.file <- 'example_20'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_20.txt')
variable.name <- ProjectTemplate:::clean.variable.name('example_20')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.20)

# Example 21: WSV File with .txt Extension and BZip2 Compression
print('Example 21: Testing .txt.bz2 support')
data.file <- 'example_21'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_21.txt.bz2')
variable.name <- ProjectTemplate:::clean.variable.name('example_21')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.21)

# Example 22: WSV File with .txt Extension and Zip Compression
#print('Example 22: Testing .txt.zip support')
#data.file <- 'example_22'
#filename <- file.path(system.file('example_data',
#                                  package = 'ProjectTemplate'),
#                      'example_22.txt.zip')
#variable.name <- ProjectTemplate:::clean.variable.name('example_22')
#
#ProjectTemplate:::wsv.reader(data.file, filename, variable.name)
#
#expect_that(exists(variable.name), is_true())
#expect_that(nrow(get(variable.name)), equals(5))
#expect_that(ncol(get(variable.name)), equals(2))
#expect_that(get(variable.name)[5, 2], equals(11))
#rm(example.22)

# Example 23: WSV File with .txt Extension and GZip Compression
print('Example 23: Testing .txt.gz support')
data.file <- 'example_23'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_23.txt.gz')
variable.name <- ProjectTemplate:::clean.variable.name('example_23')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.23)

# Example 24: R File with .R Extension
print('Example 24: Testing .R support')
data.file <- 'example_24'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_24.R')
variable.name <- ProjectTemplate:::clean.variable.name('example_24')

ProjectTemplate:::r.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.24)

# Example 25: R File with .r Extension
print('Example 25: Testing .r support')
data.file <- 'example_25'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_25.r')
variable.name <- ProjectTemplate:::clean.variable.name('example_25')

ProjectTemplate:::r.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.25)

# Example 26: Excel 2007 File with .xls Extension
print('Example 26: Testing .xls support')
data.file <- 'example_26'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_26.xls')
variable.name <- ProjectTemplate:::clean.variable.name('example_26')

ProjectTemplate:::xls.reader(data.file, filename, variable.name)

variable.name <- paste(variable.name, '.Sheet1', sep = '')

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.26.Sheet1)

# Example 27: Excel 2011 File with .xlsx Extension
print('Example 27: Testing .xlsx support')
data.file <- 'example_27'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_27.xlsx')
variable.name <- ProjectTemplate:::clean.variable.name('example_27')

ProjectTemplate:::xlsx.reader(data.file, filename, variable.name)

variable.name <- paste(variable.name, '.Sheet1', sep = '')

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.27.Sheet1)

# Example 28: SQLite3 Support with .sql Extension
print('Example 28: Testing .sql support')
sql.file <- data.frame(type = 'sqlite',
                       dbname = file.path(system.file('example_data',
                                                      package = 'ProjectTemplate'),
                                          'example_28.db'),
                       table = 'example_28')
write.dcf(sql.file, file = 'example_28.sql', width = 500)

data.file <- 'example_28'
filename <- 'example_28.sql'
variable.name <- ProjectTemplate:::clean.variable.name('example_28')

ProjectTemplate:::sql.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.28)
