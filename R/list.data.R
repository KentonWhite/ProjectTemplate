#' Listing the data for the current project
#'
#' This function produces a data.frame of all data files in the project, with
#'   meta data on if and how the file will be loaded by \code{load.project}.
#'
#' @param override.config Named list, allows overriding individual configuration
#'   items.
#'
#' @return A data.frame listing the available data, with relevant meta data
#'
#' @details The returned data.frame contains the following variables, with one
#'   observation per file in \code{data/}:
#'
#' \tabular{ll}{
#'    \code{filename} \tab Character variable containing the filename relative
#'      to \code{data/} directory. \cr
#'    \code{varname} \tab Character variable containing the name of the
#'      variable into which the file will be imported. * \cr
#'    \code{is_ignored} \tab Logical variable that indicates whether the file.
#'      is ignored through the \code{data_ignore} option in the configuration \cr
#'    \code{is_directory} \tab Logical variable that indicates whether the file
#'      is a directory. \cr
#'    \code{is_cached} \tab Logical variable that indicates whether the file is
#'      already available in the \code{cache/} directory. \cr
#'    \code{cached_only} \tab Logical variable that indicates whether the
#'      variable is only available in the \code{cache/} directory. This occurs
#'      when calling the cache function with a code fragment in a munge script. \cr
#'    \code{reader} \tab Character variable containing the name of the reader
#'      function that will be used to load the data. Contains a \code{character(0)}
#'      if no suitable reader was found.
#' }
#'
#' * Note that some readers return more than one variable, usually with the
#'   listed variablename as prefix. This is true for for example the
#'   \code{xls.reader} and \code{xlsx.reader}.
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
  # Get list of variables in data/, always recursive to exclude cached
  # variables from nested files
  all.files <- list.files(path = 'data', recursive = TRUE, include.dirs = TRUE)
  # Get list of variables according to configured recursive_loading, used as
  # filtering variable later
  data.files <- list.files(path = 'data', recursive = config$recursive_loading,
                           include.dirs = !config$recursive_loading)

  # Get variable name and reader from filenames
  files.parsed <- .parse.extensions(all.files)
  varnames <- files.parsed$varnames
  readers <- files.parsed$readers

  is_ignored <- grepl(.prepare.data.ignore.regex(config$data_ignore),
                      all.files)
  is_directory <- file.info(file.path('data', all.files))$isdir

  is_cached <- .is.cached(varnames)
  cache_only <- rep(FALSE, length(varnames))

  # Build the final data.frame
  df <- data.frame(filename = all.files,
                   varname = varnames,
                   is_ignored = is_ignored,
                   is_directory = is_directory,
                   is_cached = is_cached,
                   cache_only = cache_only,
                   reader = readers,
                   stringsAsFactors = FALSE)
  # Keep only lines with files that match the configured recursive_loading
  # setting
  df <- df[df$filename %in% data.files,]
  df <- df[order(df$reader == "file.reader", decreasing = TRUE),]
  df <- df[!duplicated(df$varname, incomparables = ""),]
  # Get list of variables in cache/
  cached.vars <- .cached.variables()
  # Exclude variables already found in data/
  cached.vars <- setdiff(cached.vars, varnames)

  filenames <- rep('', length(cached.vars))
  is_ignored <- rep(FALSE, length(cached.vars))
  is_directory <- rep(FALSE, length(cached.vars))
  cache_only <- rep(TRUE, length(cached.vars))
  readers <- rep('', length(cached.vars))

  # .cached.variables returns all variables without checking validity, need to
  # call .is.cached to perform this check
  is_cached <- .is.cached(cached.vars)

  df2 <- data.frame(filename = filenames,
                    varname = cached.vars,
                    is_ignored = is_ignored,
                    is_directory = is_directory,
                    is_cached = is_cached,
                    cache_only = cache_only,
                    reader = readers,
                    row.names = NULL,
                    stringsAsFactors = FALSE)

  rbind(df, df2)
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

.prepare.data.ignore.regex <- function(ignore_files) {
  ignore_files <- strsplit(ignore_files, '\\s*,\\s*')[[1]]
  regexes <- ignore_files[grepl('^/.*/$', ignore_files)]
  literals <- setdiff(ignore_files, regexes)

  # Create regex for special characters in regex to be escaped
  #  (welcome to backslash hell)
  # Note that * is a regex special character but often used in literals as
  #  wildcard
  regex.special <- c('.', '\\', '|', '(', ')', '[', '{', '^', '$', '+', '?')
  regex.special <- paste0('([',
                          paste0('\\', regex.special, collapse = '|'),
                          '])')
  # Escape special characters in literal strings
  literals <- gsub(regex.special, '\\\\\\1', literals)
  # Escape wildcard * in literal strings
  literals <- gsub('\\*', '\\.\\*', literals)
  # Convert trailing slash to wildcard
  literals <- gsub('/$', '/\\.\\*', literals)
  literals <- paste0('^', literals, '$')

  # Remove starting and trailing slashes from regexes
  regexes <- gsub('(^/)|(/$)', '', regexes)

  # Combine and return prepared regexes
  paste0(c(literals, regexes), collapse = '|')
}
