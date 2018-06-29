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
#' @param rstudio.project A boolean value indicating whether the project should
#'   also be an 'RStudio Project'. Defaults to \code{FALSE}. If \code{TRUE},
#'   then a `projectname.Rproj` with usable defaults is added to the ProjectTemplate
#'   directory.
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
                           dump = FALSE, merge.strategy = c("require.empty", "allow.non.conflict"),
                           rstudio.project = FALSE)
{

  .stopifproject(c("Cannot create a new project inside an existing one",
                           "Please change to another directory and re-run create.project()"),
                 path = normalizePath(dirname(project.name)))

  .stopifproject(c("Cannot create a new project inside an existing one",
                   "Please change to another directory and re-run create.project()"),
                 path = dirname(normalizePath(dirname(project.name))))

  merge.strategy <- match.arg(merge.strategy)
  if (.is.dir(project.name)) {
    .create.project.existing(project.name, merge.strategy, template, rstudio.project)
  } else
    .create.project.new(project.name, template, rstudio.project)

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


#' Create a project structure
#'
#' \code{.create.project.existing} creates a project directory structure inside
#' an existing directory with the default files from a given template.
#'
#' @param project.name Character vector with the name of the project directory
#' @param merge.strategy Character vector determining whether the directory
#'   should be empty or is allowed to contain non-conflicting files
#' @param template Name of the template from which the project should be created
#' @param rstudio.project Logical indicating whether an \code{.Rproj} file
#'   should be created
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @seealso \code{\link{create.project}}, \code{\link{create.template}}
#' @keywords internal
#'
#' @rdname internal.create.project
.create.project.existing <- function(project.name, merge.strategy, template, rstudio.project) {
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

  # Add RProj file to the project directory if the user has requested an RStudio project
  if(rstudio.project){
    rstudiopath <- file.path(project.path, paste0(project.name,'.Rproj'))
    writeLines(.rstudioprojectfile(), rstudiopath)
  }
}


#' Create project in a new directory
#'
#' \code{.create.project.new} first creates a new directory and then passes
#' further control to \code{.create.project.existing}. In case the project
#' creation fails, the newly created directory is cleaned up.
#'
#' @inherit .create.project.existing params return
#'
#' @keywords internal
#'
#' @rdname internal.create.project
.create.project.new <- function(project.name, template, rstudio.project) {
  if (file.exists(project.name)) {
    stop(paste("Cannot run create.project() from a directory containing", project.name))
  }

  dir.create(project.name)
  tryCatch(
    .create.project.existing(project.name = project.name,
                             merge.strategy = "require.empty",
                             template = template,
                             rstudio.project = rstudio.project),
    error = function(e) {
      unlink(project.name, recursive = TRUE)
      stop(e)
    }
  )
}


#' List all files and directories, excluding .. and .
#'
#' Creates a directory listing of a given path, including hidden files and
#' subdirectories, but excluding the .. and . aliases.
#'
#' @param path Character vector indicating the path to the parent folder of
#'   which the contents should be listed.
#'
#' @return Directory listing of \code{path}
#'
#' @keywords internal file deprecate
#'
#' @rdname internal.list.files.and.dirs
.list.files.and.dirs <- function(path) {
  # no.. not available in R 2.15.3
  files <- list.files(path = path, all.files = TRUE, include.dirs = TRUE)
  files <- grep("^[.][.]?$", files, value = TRUE, invert = TRUE)
  files
}


#' Check if path is an existing directory
#'
#' Checks if a given path exists, and if so if it is a directory.
#'
#' @param path Character vector containing the path to the directory to check.
#'
#' @return Logical indicating a valid directory was passed.
#'
#' @keywords internal file
#'
#' @rdname internal.is.dir
.is.dir <- function(path) {
  file.exists(path) && file.info(path)$isdir
}


#' Check if a directory is empty
#'
#' Checks if the directory listing by \code{\link{.list.files.and.dirs}} is empty.
#'
#' @param path Character vector containing the path to the directory to check.
#'
#' @return Logical indicating whether the passed directory was empty.
#'
#' @keywords internal file
#'
#' @rdname internal.dir.empty
.dir.empty <- function(path) {
  length(.list.files.and.dirs(path = path)) == 0
}


#' Return an RStudio project file as character vector
#'
#' @return Character vector with the contents of an empty RStudio project file
#'
#' @keywords internal
#'
#' @rdname internal.rstudioprojectfile
.rstudioprojectfile <- function(){
  return("Version: 1.0\n\nRestoreWorkspace: Default\nSaveWorkspace: Default\nAlwaysSaveHistory: Default\n\nEnableCodeIndexing: Yes\nUseSpacesForTab: Yes\nNumSpacesForTab: 4\nEncoding: UTF-8\n\nRnwWeave: Sweave\nLaTeX: pdfLaTeX\n\nStripTrailingWhitespace: Yes")
}
