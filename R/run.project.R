run.project <- function()
{
  message('Running project analyses from src')

  for (analysis.script in dir('src'))
  {
    if (grepl('\\.R$', analysis.script, ignore.case = TRUE))
    {
      message(paste(' Running analysis script:', analysis.script))
      system(paste('Rscript', file.path('src', analysis.script)))
    }
  }
}
