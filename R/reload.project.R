reload.project <- function()
{
  rm(list = ls(.GlobalEnv), pos = .GlobalEnv)
  load.project()
}
