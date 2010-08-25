data.files <- dir('data')

for (data.file in data.files)
{
  filename <- file.path('data', data.file)

  if (grepl('\\.csv$', data.file, perl = TRUE))
  {
    variable.name <- sub('\\.csv$', '', data.file, perl = TRUE)
    variable.name <- clean.variable.name(variable.name)
    assign(variable.name, read.csv(filename, header = TRUE, sep = ','))
  }
  
  if (grepl('\\.tsv$', data.file, perl = TRUE))
  {
    variable.name <- sub('\\.tsv$', '', data.file, perl = TRUE)
    variable.name <- clean.variable.name(variable.name)
    assign(variable.name, read.csv(filename, header = TRUE, sep = '\t'))
  }
}
