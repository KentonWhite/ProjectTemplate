#' Listing the data for the current project
#'
#' This function produces a data.frame of all data files in the project, with
#'   the following meta data:
#'
#' @param override.config Named list, allows overriding individual configuration
#'   items.
#'
#' @return df data.frame containing available data with relevant meta data
#'
#' @export
#'
#' @seealso \code{\link{load.project}}, \code{\link{show.project}},
#'    \code{\link{project.config}}
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{list.data()}
list.data <- function(override.config = NULL) {
  config <- .load.config(override.config)
  .list.data(config)
}

.list.data <- function(config) {
  data.files <- list.files(path = 'data', recursive = config$recursive_loading)
  readers.and.varnames <- .parse.extensions(data.files)

  is_ignored <- grepl(.prepare.data.ignore.regex(config$data_ignore),
                      data.files)
  is_directory <- file.info(file.path('data', data.files))$isdir
  is_cached <- .is.cached(readers.and.varnames$varnames)

  # Build the final data.frame
  df <- data.frame(filename = data.files,
                   varname = readers.and.varnames$varnames,
                   is_ignored = is_ignored,
                   is_directory = is_directory,
                   is_cached = is_cached,
                   reader = readers.and.varnames$readers,
                   stringsAsFactors = FALSE)
  df
}

.parse.extensions <- function(data.files) {
  readers <- character(length(data.files))
  varnames <- character(length(data.files))

  for (extension in ls(extensions.dispatch.table)) {
    extension.match <- grepl(extension, data.files,
                             ignore.case = TRUE, perl = TRUE)
    readers[extension.match] <- extensions.dispatch.table[[extension]]
    varnames[extension.match] <- sub(extension, '', data.files[extension.match],
                                     ignore.case = TRUE, perl = TRUE)
    varnames[extension.match] <- clean.variable.name(varnames[extension.match])
  }

  list(readers = readers, varnames = varnames)
}

.is.cached <- function(varnames) {
  is.cached <- logical(length(varnames))
  for (v in seq_along(varnames)) {
    is.cached[v] <- .read.cache.info(varnames[v])$in.cache
  }
  is.cached
}
