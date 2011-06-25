run.project <- function()
{
  message('Running project analyses from src')

  for (analysis.script in dir('src'))
  {
    if (grepl('\\.R$', ignore.case = TRUE, analysis.script))
    {
      message(paste(' Running analysis script:', analysis.script))
      system(paste('Rscript', file.path('src', analysis.script)))
    }
  }
}
