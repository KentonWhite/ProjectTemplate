library('testthat')

library('ProjectTemplate')

library('Defaults')

# testthat by default runs tests in the parent environment to global
# This gives access to pacakges and keeps the test from polluting the global environment
# However, the global environment is not in the test seach path
# The global environment is needed for the objects created by the readers being tested
# 
# Solution is to set the global environment as the parent of the test environment
# Then the global environment is part of the test environment search path

if (!identical(environment(), .GlobalEnv))
{
	test.env <- environment()
	parent.env(test.env) <- .GlobalEnv

	setDefaults("rm", inherits = TRUE)	
}

# Example 01: CSV Data File
message('Example 01: Testing .csv support')
data.file <- 'example_01.csv'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_01.csv')
variable.name <- ProjectTemplate:::clean.variable.name('example_01')

ProjectTemplate:::csv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.01)

# Example 02: CSV Data File with BZip2 Compression
message('Example 02: Testing .csv.bz2 support')
data.file <- 'example_02.csv.bz2'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_02.csv.bz2')
variable.name <- ProjectTemplate:::clean.variable.name('example_02')

ProjectTemplate:::csv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.02)

# Example 03: CSV Data File with Zip Compression
message('Example 03: Testing .csv.zip support')
data.file <- 'example_03.csv.zip'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_03.csv.zip')
variable.name <- ProjectTemplate:::clean.variable.name('example_03')

ProjectTemplate:::csv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.03)

# Example 04: CSV Data File with GZip Compression
message('Example 04: Testing .csv.gz support')
data.file <- 'example_04.csv.gz'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_04.csv.gz')
variable.name <- ProjectTemplate:::clean.variable.name('example_04')

ProjectTemplate:::csv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.04)

# Example 05: TSV Data File
message('Example 05: Testing .tsv support')
data.file <- 'example_05.tsv'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_05.tsv')
variable.name <- ProjectTemplate:::clean.variable.name('example_05')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.05)

# Example 06: TSV Data File with BZip2 Compression
message('Example 06: Testing .tsv.bz2 support')
data.file <- 'example_06.tsv.bz2'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_06.tsv.bz2')
variable.name <- ProjectTemplate:::clean.variable.name('example_06')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.06)

# Example 07: TSV Data File with Zip Compression
message('Example 07: Testing .tsv.zip support')
data.file <- 'example_07.tsv.zip'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_07.tsv.zip')
variable.name <- ProjectTemplate:::clean.variable.name('example_07')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.07)

# Example 08: TSV Data File with GZip Compression
message('Example 08: Testing .tsv.gz support')
data.file <- 'example_08.tsv.gz'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_08.tsv.gz')
variable.name <- ProjectTemplate:::clean.variable.name('example_08')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.08)

# Example 09: WSV Data File
message('Example 09: Testing .wsv support')
data.file <- 'example_09.wsv'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_09.wsv')
variable.name <- ProjectTemplate:::clean.variable.name('example_09')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.09)

# Example 10: WSV Data File with BZip2 Compression
message('Example 10: Testing .wsv.bz2 support')
data.file <- 'example_10.wsv.bz2'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_10.wsv.bz2')
variable.name <- ProjectTemplate:::clean.variable.name('example_10')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.10)

# Example 11: WSV Data File with Zip Compression
message('Example 11: Testing .wsv.zip support')
data.file <- 'example_11.wsv.zip'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_11.wsv.zip')
variable.name <- ProjectTemplate:::clean.variable.name('example_11')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.11)

# Example 12: WSV Data File with GZip Compression
message('Example 12: Testing .wsv.gz support')
data.file <- 'example_12.wsv.gz'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_12.wsv.gz')
variable.name <- ProjectTemplate:::clean.variable.name('example_12')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.12)

# Example 13: RData Data File with .RData Extension
message('Example 13: Testing .RData support')
data.file <- 'example_13.RData'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_13.RData')
variable.name <- ProjectTemplate:::clean.variable.name('example_13')

ProjectTemplate:::rdata.reader(data.file, filename, variable.name)

expect_that(exists('m'), is_true())
expect_that(names(get('m')), equals(c('N', 'Prime')))
expect_that(nrow(get('m')), equals(5))
expect_that(ncol(get('m')), equals(2))
expect_that(get('m')[5, 2], equals(11))
rm('m')

# Example 14: RData Data File with .rda Extension
message('Example 14: Testing .rda support')
data.file <- 'example_14.rda'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_14.rda')
variable.name <- ProjectTemplate:::clean.variable.name('example_14')

ProjectTemplate:::rdata.reader(data.file, filename, variable.name)

expect_that(exists('n'), is_true())
expect_that(names(get('n')), equals(c('N', 'Prime')))
expect_that(nrow(get('n')), equals(5))
expect_that(ncol(get('n')), equals(2))
expect_that(get('n')[5, 2], equals(11))
rm('n')

# Example 15: URL File with .url Extension
message('Skipping Example 15: Testing .url support')

# Example 16: TSV File with .tab Extension
message('Example 16: Testing .tab support')
data.file <- 'example_16.tab'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_16.tab')
variable.name <- ProjectTemplate:::clean.variable.name('example_16')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.16)

# Example 17: TSV File with .tab Extension and BZip2 Compression
message('Example 17: Testing .tab.bz2 support')
data.file <- 'example_17.tab.bz2'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_17.tab.bz2')
variable.name <- ProjectTemplate:::clean.variable.name('example_17')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.17)

# Example 18: TSV File with .tab Extension and Zip Compression
message('Example 18: Testing .tab.zip support')
data.file <- 'example_18.tab.zip'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_18.tab.zip')
variable.name <- ProjectTemplate:::clean.variable.name('example_18')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.18)

# Example 19: TSV File with .tab Extension and GZip Compression
message('Example 19: Testing .tab.gz support')
data.file <- 'example_19.tab.gz'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_19.tab.gz')
variable.name <- ProjectTemplate:::clean.variable.name('example_19')

ProjectTemplate:::tsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.19)

# Example 20: WSV File with .txt Extension
message('Example 20: Testing .txt support')
data.file <- 'example_20.txt'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_20.txt')
variable.name <- ProjectTemplate:::clean.variable.name('example_20')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.20)

# Example 21: WSV File with .txt Extension and BZip2 Compression
message('Example 21: Testing .txt.bz2 support')
data.file <- 'example_21.txt.bz2'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_21.txt.bz2')
variable.name <- ProjectTemplate:::clean.variable.name('example_21')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.21)

# Example 22: WSV File with .txt Extension and Zip Compression
message('Skipping Example 22: Testing .txt.zip support')
data.file <- 'example_22.txt.zip'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_22.txt.zip')
variable.name <- ProjectTemplate:::clean.variable.name('example_22')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.22)

# Example 23: WSV File with .txt Extension and GZip Compression
message('Example 23: Testing .txt.gz support')
data.file <- 'example_23.txt.gz'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_23.txt.gz')
variable.name <- ProjectTemplate:::clean.variable.name('example_23')

ProjectTemplate:::wsv.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.23)

# Example 24: R File with .R Extension
message('Example 24: Testing .R support')
data.file <- 'example_24.R'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_24.R')
variable.name <- ProjectTemplate:::clean.variable.name('example_24')

ProjectTemplate:::r.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.24)

# Example 25: R File with .r Extension
message('Example 25: Testing .r support')
data.file <- 'example_25.r'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_25.r')
variable.name <- ProjectTemplate:::clean.variable.name('example_25')

ProjectTemplate:::r.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.25)

# Example 26: Excel 2007 File with .xls Extension
message('Example 26: Testing .xls support')
data.file <- 'example_26.xls'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_26.xls')
variable.name <- ProjectTemplate:::clean.variable.name('example_26')

ProjectTemplate:::xls.reader(data.file, filename, variable.name)

variable.name <- paste(variable.name, '.Sheet1', sep = '')

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.26.Sheet1)

# Example 27: Excel 2011 File with .xlsx Extension
#message('Example 27: Testing .xlsx support')
#data.file <- 'example_27.xlsx'
#filename <- file.path(system.file('example_data',
#                                  package = 'ProjectTemplate'),
#                      'example_27.xlsx')
#variable.name <- ProjectTemplate:::clean.variable.name('example_27')
#
#ProjectTemplate:::xlsx.reader(data.file, filename, variable.name)
#
#variable.name <- paste(variable.name, '.Sheet1', sep = '')
#
#expect_that(exists(variable.name), is_true())
#expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
#expect_that(nrow(get(variable.name)), equals(5))
#expect_that(ncol(get(variable.name)), equals(2))
#expect_that(get(variable.name)[5, 2], equals(11))
#rm(example.27.Sheet1)

# Example 28: SQLite3 Support with .sql Extension with table = "..."
message('Example 28: Testing .sql with table = "x" support')
sql.file <- data.frame(type = 'sqlite',
                       dbname = file.path(system.file('example_data',
                                                      package = 'ProjectTemplate'),
                                          'example_28.db'),
                       table = 'example_28')
write.dcf(sql.file, file = 'example_28.sql', width = 1000)

data.file <- 'example_28.sql'
filename <- 'example_28.sql'
variable.name <- ProjectTemplate:::clean.variable.name('example_28')

ProjectTemplate:::sql.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.28)
unlink('example_28.sql')

# Example 29: SQLite3 Support with .sql Extension with query = "SELECT * FROM ..."
message('Example 29: Testing .sql with query = "x" support')
sql.file <- data.frame(type = 'sqlite',
                       dbname = file.path(system.file('example_data',
                                                      package = 'ProjectTemplate'),
                                          'example_29.db'),
                       query = 'SELECT * FROM example_29')
write.dcf(sql.file, file = 'example_29.sql', width = 1000)

data.file <- 'example_29.sql'
filename <- 'example_29.sql'
variable.name <- ProjectTemplate:::clean.variable.name('example_29')

ProjectTemplate:::sql.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.29)
unlink('example_29.sql')

# Example 30: SQLite3 Support with .sql Extension and table = "*"
message('Example 30: Testing .sql with table = "*" support')
sql.file <- data.frame(type = 'sqlite',
                       dbname = file.path(system.file('example_data',
                                                      package = 'ProjectTemplate'),
                                          'example_30.db'),
                       table = '*')
write.dcf(sql.file, file = 'example_30.sql', width = 1000)

data.file <- 'example_30.sql'
filename <- 'example_30.sql'
variable.name <- ProjectTemplate:::clean.variable.name('example_30')

ProjectTemplate:::sql.reader(data.file, filename, variable.name)

variable1.name <- ProjectTemplate:::clean.variable.name('example_30a')
variable2.name <- ProjectTemplate:::clean.variable.name('example_30b')
expect_that(exists(variable1.name), is_true())
expect_that(names(get(variable1.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable1.name)), equals(5))
expect_that(ncol(get(variable1.name)), equals(2))
expect_that(get(variable1.name)[5, 2], equals(11))
rm(example.30a)
expect_that(exists(variable2.name), is_true())
expect_that(names(get(variable2.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable2.name)), equals(5))
expect_that(ncol(get(variable2.name)), equals(2))
expect_that(get(variable2.name)[5, 2], equals(11))
rm(example.30b)
rm(example.30)
unlink('example_30.sql')

# Example 31: SQLite3 Support with .db Extension
message('Example 31: Testing .db support')
data.file <- 'example_31.db'
filename <- file.path(system.file('example_data',
                                package = 'ProjectTemplate'),
                      'example_31.db')
variable.name <- ProjectTemplate:::clean.variable.name('example_31')

ProjectTemplate:::db.reader(data.file, filename, variable.name)

variable1.name <- ProjectTemplate:::clean.variable.name('example_31a')
variable2.name <- ProjectTemplate:::clean.variable.name('example_31b')
expect_that(exists(variable1.name), is_true())
expect_that(names(get(variable1.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable1.name)), equals(5))
expect_that(ncol(get(variable1.name)), equals(2))
expect_that(get(variable1.name)[5, 2], equals(11))
rm(example.31a)
expect_that(exists(variable2.name), is_true())
expect_that(names(get(variable2.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable2.name)), equals(5))
expect_that(ncol(get(variable2.name)), equals(2))
expect_that(get(variable2.name)[5, 2], equals(11))
rm(example.31b)

# Example 32: Weka Support with .arff Extension
message('Example 32: Testing .arff support')
data.file <- 'example_32.arff'
filename <- file.path(system.file('example_data',
                                package = 'ProjectTemplate'),
                      'example_32.arff')
variable.name <- ProjectTemplate:::clean.variable.name('example_32')

ProjectTemplate:::arff.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.32)

# Example 33: Arbitary File Support with .file File Pointing to .db File
message('Example 33: Testing .file support')
info.file <- data.frame(path = file.path(system.file('example_data',
                                                      package = 'ProjectTemplate'),
                                          'example_28.db'),
                       extension = 'db')
write.dcf(info.file, file = 'example_33.file', width = 1000)

data.file <- 'example_33.file'
filename <- 'example_33.file'
variable.name <- ProjectTemplate:::clean.variable.name('example_28')

ProjectTemplate:::file.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.28)
unlink('example_33.file')

# Example 34: MP3 Support with .mp3 Extension
message('Skipping Example 34: Testing .mp3 support')

# Example 35: PPM Support with .ppm Extension
message('Example 35: Testing .ppm support')
data.file <- 'example_35.ppm'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_35.ppm')
variable.name <- ProjectTemplate:::clean.variable.name('example_35')

ProjectTemplate:::ppm.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(as.character(class(get(variable.name))), equals('pixmapRGB'))
rm(example.35)

# Example 36: dBase Support with .dbf Extension
message('Example 36: Testing .dbf support')
data.file <- 'example_36.dbf'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_36.dbf')
variable.name <- ProjectTemplate:::clean.variable.name('example_36')

ProjectTemplate:::dbf.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.36)

# Example 37: SPSS Support with .sav Extension
message('Example 37: Testing .sav support')
data.file <- 'example_37.sav'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_37.sav')
variable.name <- ProjectTemplate:::clean.variable.name('example_37')

ProjectTemplate:::spss.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.37)

# Example 38: SPSS Support with .sav Extension / Alternative Generation
message('Example 38: Testing .sav support')
data.file <- 'example_38.sav'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_38.sav')
variable.name <- ProjectTemplate:::clean.variable.name('example_38')

ProjectTemplate:::spss.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.38)

# Example 39: Stata Support with .dta Extension
message('Example 39: Testing .dta support')
data.file <- 'example_39.dta'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_39.dta')
variable.name <- ProjectTemplate:::clean.variable.name('example_39')

ProjectTemplate:::stata.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.39)

# Example 40: Stata Support with .dta Extension / Alternative Generation
message('Example 40: Testing .dta support')
data.file <- 'example_40.dta'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_40.dta')
variable.name <- ProjectTemplate:::clean.variable.name('example_40')

ProjectTemplate:::stata.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'Prime')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.40)

# Example 41: SAS Support with .xport Extension
message('Example 41: Testing .xport support')
data.file <- 'example_41.xport'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_41.xport')
variable.name <- ProjectTemplate:::clean.variable.name('example_41')

ProjectTemplate:::xport.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'PRIME')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.41)

# Example 42: SAS Support with .xpt Extension
message('Example 42: Testing .xpt support')
data.file <- 'example_42.xpt'
filename <- file.path(system.file('example_data',
                                  package = 'ProjectTemplate'),
                      'example_42.xpt')
variable.name <- ProjectTemplate:::clean.variable.name('example_42')

ProjectTemplate:::xport.reader(data.file, filename, variable.name)

expect_that(exists(variable.name), is_true())
expect_that(names(get(variable.name)), equals(c('N', 'PRIME')))
expect_that(nrow(get(variable.name)), equals(5))
expect_that(ncol(get(variable.name)), equals(2))
expect_that(get(variable.name)[5, 2], equals(11))
rm(example.42)

# Example 43: ElasticSearch Support with .es Extension
message('Skipping Example 43: Testing .es support')
