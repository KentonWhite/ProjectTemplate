#' Run all unit tests for this project.
#'
#' This function will run all of the \code{testthat} style unit tests
#' for the current project that are defined inside of the \code{tests}
#' directory. The tests will be run in the order defined by the filenames
#' for the tests: it is recommend that each test begin with a number
#' specifying its position in the sequence.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{load.project()
#'
#' test.project()}
test.project <- function()
{
  load.project()
  require.package('testthat', attach = TRUE)

  files = dir('tests', full.names = TRUE)
  # Versions of testhat <0.8.0 use global enclosure
  # >0.8.0 use parent of global
  # Need to call test_file appropriately

  if (packageVersion('testthat') < '0.8.0')
  {
    invisible(lapply(files, testthat::test_file))
  } else {
    invisible(lapply(files, testthat::test_file, env = environment()))
  }
}
