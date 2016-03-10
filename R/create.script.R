#' Create new script template
#'
#' This will create new scripts from template in the appropriate folder of
#' the currently loaded project as defined by \code{getwd()} where the wd
#' is a project created by \code{ProjectTemplate::create.project}.
#' The following \code{scripttype} options will be available:
#'
#'  * data
#'  * src
#'  * munge
#'  * test
#'  * graphs
#'  * profiling
#'
#'  Global options:
#'
#'  All new scripts will have an option of setting \code{filename},
#'  \code{date} and \code{author} can also be included.
#'  \code{date} is set to \code{Sys.Date()} by default.
#'
#'  @param filename A character variable containing the desired filename
#'    for the new script.
#'  @param date A date variable containing the date created.
#'  @param author A character variable containing the author(s) of the
#'    project.
#'  @param merge.strategy Inherited from create.project. What happens
#'    if the file exists in the designated directory?
#'
#'  @return No value is returned. This is called for its side effects.
#'
#'  @details
#'
#'  @seealso
#'
#'  @examples
#'  library(ProjectTemplate)
#'
#'  \dontrun{create.script(filename = "informativeName", scripttype = "data", author = "tomschloss", date = "2016-03-10")}

create.script <- function(filename = "newscript",
                          scripttype, author = "", date = Sys.Date()){
  curr_dir <- getwd()
  switch(scripttype,
            data = {
           .check.folder.exists(curr_dir, "data")
           filename <- paste0(filename, ".R")
           .check.file(curr_dir, filename)},
           src = {
             .create.file()
           }
  )

}


.check.folder.exists <- function(dir, foldername){



}

