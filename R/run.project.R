#' Run all of the analyses in the \code{src} directory.
#'
#' This function will run each of the analyses in the \code{src}
#' directory in separate processes. At present, this is done serially, but
#' future versions of this function will provide a means of running
#' the analyses in parallel.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{run.project()}
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
