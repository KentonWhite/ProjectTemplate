run.tests <- function()
{
  load.project()
  library('testthat')
  test_dir('tests', reporter = 'summary')
}

test.project <- run.tests
