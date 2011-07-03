test.project <- function()
{
  load.project()
  library('testthat')
  test_dir('tests', reporter = 'summary')
}
