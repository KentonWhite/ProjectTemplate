show.updates <- function()
{
  default.files <- dir(system.file('defaults', package = 'ProjectTemplate'))
  for (default.file in default.files)
  {
    canonical.file <- file.path(system.file('defaults', package = 'ProjectTemplate'), default.file)
    # Shell escape this.
    diff.command <- paste('diff -r',
                          default.file,
                          canonical.file,
                          '2>&1')
    diff.output <- system(diff.command, intern = TRUE)
    if (length(diff.output) > 0 || nchar(diff.output) != 0)
    {
      cat(paste('Your copy of', default.file, 'differs from the current ProjectTemplate version.\n'))
      cat(paste('You might want to consider merging changes from\n'))
      cat(paste(canonical.file, '\n', sep = ''))
      cat('\n')
    }
  }
}
