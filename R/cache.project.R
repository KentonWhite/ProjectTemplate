cache.project <- function()
{
  for (dataset in project.info[['data']])
  {
    message(paste('Caching', dataset))
    cache(dataset)
  }
}
