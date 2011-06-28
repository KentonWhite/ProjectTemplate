library('testthat')

library('ProjectTemplate')

# Example 01: CSV Data File
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

# Example 08: CSV Data File with GZip Compression
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
