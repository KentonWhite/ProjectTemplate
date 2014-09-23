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
#' @seealso \code{\link{load.project}}, \code{\link{get.project}},
#'   \code{\link{cache.project}}, \code{\link{show.project}}
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
  temp.dir <- tempfile("ProjectTemplate")
  on.exit(unlink(temp.dir, recursive = TRUE), add = TRUE)
  untar(.get.template.tar.path(template.name), exdir = temp.dir,
        tar = "internal")
  template.path <- file.path(temp.dir, template.name)

  merge.strategy <- match.arg(merge.strategy)
  if (.is.dir(project.name)) {
    .create.project.existing(template.path, project.name, merge.strategy)
  } else
    .create.project.new(template.path, project.name)

  if (dump)
  {
    1; # Magic happens here to place all of the R files from ProjectTemplate in the current folder.

    # For time being, just copy the entire contents of defaults/* and then also copy the collated R source.
    # Seriously broken at the moment.
    e <- environment(load.project)

    pt.contents <- ls(e)

    for (item in pt.contents)
    {
      cat(deparse(get(item, envir = e)),
          file = file.path(project.name, paste(item, '.R', sep = '')))
    }
  }

  invisible(NULL)
}

.create.project.existing <- function(template.path, project.name,
                                     merge.strategy) {
  template.files <- .list.files.and.dirs(path = template.path)

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

  file.copy(from = system.file('defaults/config/global.dcf', package = 'ProjectTemplate'),
            to = file.path(project.path, 'config/global.dcf'))
}

.create.project.new <- function(template.path, project.name) {
  if (file.exists(project.name)) {
    stop(paste("Cannot run create.project() from a directory containing", project.name))
  }

  dir.create(project.name)
  tryCatch(
    .create.project.existing(template.path = template.path,
                             project.name = project.name,
                             merge.strategy = "require.empty"),
    error = function(e) {
      unlink(project.name, recursive = TRUE)
      stop(e)
    }
  )
}

.get.template.tar.path <- function(template.name)
  system.file(file.path('defaults', paste0(template.name, ".tar")), package = 'ProjectTemplate')

.list.files.and.dirs <- function(path) {
  # no.. not available in R 2.15.3
  files <- list.files(path = path, all.files = TRUE, include.dirs = TRUE)
  files <- grep("^[.][.]?$", files, value = TRUE, invert = TRUE)
  files
}

.is.dir <- function(path) {
  file.exists(path) && file.info(path)$isdir
}

.dir.empty <- function(path) {
  length(.list.files.and.dirs(path = path)) == 0
}
