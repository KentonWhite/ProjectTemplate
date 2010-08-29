data.files <- dir('data')

for (data.file in data.files)
{
  filename <- file.path('data', data.file)

  if (grepl('\\.csv$', data.file, ignore.case = TRUE, perl = TRUE))
  {
    variable.name <- sub('\\.csv$', '', data.file, ignore.case = TRUE, perl = TRUE)
    variable.name <- clean.variable.name(variable.name)
    cat(paste("Loading data set: ", variable.name, '\n', sep = ''))
    assign(variable.name, read.csv(filename, header = TRUE, sep = ','))
  }
  
  if (grepl('\\.tsv$', data.file, ignore.case = TRUE, perl = TRUE))
  {
    variable.name <- sub('\\.tsv$', '', data.file, ignore.case = TRUE, perl = TRUE)
    variable.name <- clean.variable.name(variable.name)
    cat(paste("Loading data set: ", variable.name, '\n', sep = ''))
    assign(variable.name, read.csv(filename, header = TRUE, sep = '\t'))
  }

  if (grepl('\\.wsv$', data.file, ignore.case = TRUE, perl = TRUE))
  {
    variable.name <- sub('\\.wsv$', '', data.file, ignore.case = TRUE, perl = TRUE)
    variable.name <- clean.variable.name(variable.name)
    cat(paste("Loading data set: ", variable.name, '\n', sep = ''))
    assign(variable.name, read.csv(filename, header = TRUE, sep = ' '))
  }
}
