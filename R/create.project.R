#' Create a new project.
#'
#' This function will create all of the scaffolding for a new project.
#' It will set up all of the relevant directories and their initial
#' contents. For those who only want the minimal functionality, the
#' \code{template} argument can be set to \code{minimal} to create a subset of
#' ProjectTemplate's default directories. For those who want to dump
#' all of ProjectTemplate's functionality into a directory for extensive
#' customization, the \code{dump} argument can be set to \code{TRUE}.
#'
#' @param project.name A character vector containing the name for this new
#'   project. Must be a valid directory name for your file system.
#' @param template A character vector containing the name of the template to
#'   use for this project. By default a \code{full} and \code{minimal} template
#'   are provided, but custom templates can be created using
#'   \code{create.template}.
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
create.project <- function(project.name = 'new-project', template = 'full',
                           dump = FALSE, merge.strategy = c("require.empty", "allow.non.conflict"))
{

  .stopifproject(c("Cannot create a new project inside an existing one",
                           "Please change to another directory and re-run create.project()"))

  .stopifproject(c("Cannot create a new project inside an existing one",
                   "Please change to another directory and re-run create.project()"),
                 path = dirname(getwd()))

  merge.strategy <- match.arg(merge.strategy)
  if (.is.dir(project.name)) {
    .create.project.existing(project.name, merge.strategy, template)
  } else
    .create.project.new(project.name, template)

  if (dump)
  {
    1; # Magic happens here to place all of the R files from ProjectTemplate in the current folder.

    # For time being, just copy the entire contents of defaults/* and then also copy the collated R source.
    # Seriously broken at the moment.
    e <- environment(load.project)

    pt.contents <- ls(e)

    for (item in pt.contents)
    {
      cat(deparse(get(item, envir = e, inherits = FALSE)),
          file = file.path(project.name, paste(item, '.R', sep = '')))
    }
  }

  invisible(NULL)
}

.create.project.existing <- function(project.name, merge.strategy, template) {
  template.path <- .get.template(template)
  template.files <- .list.files.and.dirs(path = template.path)

  project.path <- file.path(project.name)

  switch(
    merge.strategy,
    require.empty = {
      if (!.dir.empty(project.path))
        stop(paste("Directory", project.path,
                   "not empty.  Use merge.strategy = 'allow.non.conflict' to override."))
    },
    allow.non.conflict = {
      target.file.exists <- file.exists(file.path(project.path, template.files))
      if (any(target.file.exists))
        stop(paste("Creating a project in ", project.path,
                   " would overwrite the following existing files/directories:\n",
                   paste(template.files[target.file.exists], collapse = ', ')))
    },
    stop("Invalid value for merge.strategy:", merge.strategy))

  file.copy(file.path(template.path, template.files),
            project.path,
            recursive = TRUE, overwrite = FALSE)

  # Add project name to header
  README.md <- file.path(project.path, "README.md")
  README <- readLines(README.md)
  writeLines(c(sprintf("# %s\n", basename(normalizePath(project.name))), README), README.md)
}

.create.project.new <- function(project.name, template) {
  if (file.exists(project.name)) {
    stop(paste("Cannot run create.project() from a directory containing", project.name))
  }

  dir.create(project.name)
  tryCatch(
    .create.project.existing(project.name = project.name,
                             merge.strategy = "require.empty",
                             template = template),
    error = function(e) {
      unlink(project.name, recursive = TRUE)
      stop(e)
    }
  )
}

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
