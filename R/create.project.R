#' Create a new project.
#'
#' This function will create all of the scaffolding for a new project.
#' It will set up all of the relevant directories and their initial
#' contents. For those who only want the minimal functionality, the
#' \code{minimal} argument can be set to \code{TRUE} to create a subset of
#' ProjectTemplate's default directories. For those who want to dump
#' all of ProjectTemplate's functionality into a directory for extensive
#' customization, the \code{dump} argument can be set to \code{TRUE}.
#'
#' @param project.name A character vector containing the name for this new
#'   project. Must be a valid directory name for your file system.
#' @param minimal A boolean value indicating whether to create a minimal
#'   project or a full project. A minimal project contains only the
#'   directories strictly necessary to use ProjectTemplate and does not
#'   provide template code for profiling, unit testing or documenting your
#'   project.
#' @param dump A boolean value indicating whether the entire functionality
#'   of ProjectTemplate should be written out to flat files in the current
#'   project.
#' @param merge.strategy What should happen if the target directory exists and
#'   is not empty?
#'   If \code{"force.empty"}, the target directory must be empty;
#'   if \code{"allow.non.conflict"}, the method succeeds if no files or
#'   directories with the same name exist in the target directory.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @details  If the target directory does not exist, it is created.  Otherwise,
#'   it can only contain files and directories allowed by the merge strategy.
#'
#' @export
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{create.project('MyProject')}
create.project <- function(project.name = 'new-project', minimal = FALSE,
                           dump = FALSE, merge.strategy = c("require.empty", "allow.non.conflict"))
{
  template.name <- if (minimal) 'minimal' else 'full'
  merge.strategy <- match.arg(merge.strategy)
  if (file.exists(project.name) && file.info(project.name)$isdir) {
    .create.project.existing(template.name, project.name, merge.strategy)
  } else
    .create.project.new(template.name, project.name)

  if (dump)
  {
    1; # Magic happens here to place all of the R files from ProjectTemplate in the current folder.

    # For time being, just copy the entire contents of defaults/* and then also copy the collated R source.
    # Seriously broken at the moment.
    e <- environment(ProjectTemplate:::load.project)
    
    pt.contents <- ls(e)
    
    for (item in pt.contents)
    {
      cat(deparse(get(item, envir = e)),
          file = file.path(project.name, paste(item, '.R', sep = '')))
    }
  }

  invisible(NULL)
}

.create.project.existing <- function(template.name, project.name,
                                     merge.strategy) {
  template.path <- .get.template.path(template.name)
  template.files <- list.files(path = template.path, all.files = TRUE,
                               include.dirs = TRUE, no.. = TRUE)

  project.path <- file.path(project.name)

  switch(
    merge.strategy,
    require.empty={
      if (!.dir.empty(project.path))
        stop(paste("Directory", project.path,
                   "not empty.  Use merge.strategy = 'allow.non.conflict' to override."))
    },
    allow.non.conflict={
      target.file.exists <- file.exists(file.path(project.path, template.files))
      if (any(target.file.exists))
        stop(paste("Creating a project in ", project.path,
                   " would overwrite the following existing files/directories:\n",
                   paste(template.files[target.file.exists], collapse=', ')))
    },
    stop("Invalid value for merge.strategy:", merge.strategy))

  file.copy(file.path(template.path, template.files),
            project.path,
            recursive = TRUE, overwrite = FALSE)
}

.create.project.new <- function(template.name, project.name) {
  tmp.dir <- paste(project.name, '_tmp', sep = '')

  if (file.exists(project.name) || file.exists(tmp.dir))
  {
    stop(paste("Cannot run create.project() from a directory containing", project.name, "or", tmp.dir))
  }

  dir.create(tmp.dir)
  on.exit(unlink(tmp.dir, recursive = TRUE), add=TRUE)

  file.copy(.get.template.path(template.name),
            file.path(tmp.dir),
            recursive = TRUE)
  file.rename(file.path(tmp.dir, template.name), project.name)
}

.get.template.path <- function(template.name)
  system.file(file.path('defaults', template.name), package = 'ProjectTemplate')

.dir.empty <- function(path) {
  length(list.files(path = path, all.files = TRUE, include.dirs = TRUE,
                    no.. = TRUE)) == 0
}
