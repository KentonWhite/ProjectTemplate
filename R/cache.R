#' @include get.project.R
NULL

#' Cache a data set for faster loading.
#'
#' This function will store a copy of the named data set in the \code{cache}
#' directory. This cached copy of the data set will then be given precedence
#' at load time when calling \code{\link{load.project}}. Cached data sets are
#' stored as \code{.RData} or optionally as \code{.qs} files.
#'
#' Usually you will want to cache datasets during munging.  This can be the raw
#' data just loaded, or it can be the result of further processing during munge.  Either
#' way, it can take a while to cache large variables, so cache will only cache when it
#' needs to.
#' The \code{clear.cache("variable")} command
#' can be run to flush individual items from the cache.
#'
#' Calling \code{cache()} with no arguments returns the current status of the cache.
#'
#' @param variable A character string containing the name of the variable to
#'  be saved.  If the CODE parameter is defined, it is evaluated and saved, otherwise
#'  the variable with that name in the global environment is used.
#' @param CODE A sequence of R statements enclosed in \code{\{..\}} which produce the object to be
#' cached.
#' @param depends A character vector of other global environment objects that the CODE
#' depends upon. Caching will be forced if those objects have changed since last caching
#' @param ... Additional arguments passed on to \code{\link{save}} or optionally
#' to \code{\link[qs]{qsave}}. See \code{\link{project.config}} for further
#' information.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @export
#' @examples
#' library('ProjectTemplate')
#' \dontrun{create.project('tmp-project')
#'
#' setwd('tmp-project')
#'
#' dataset1 <- 1:5
#' cache('dataset1')
#'
#' setwd('..')
#' unlink('tmp-project')}
#'
#' @seealso \code{\link[qs]{qsave}}, \code{\link{project.config}}
cache <- function(variable=NULL, CODE=NULL, depends=NULL,  ...)
{

  project_name <- .stopifnotproject("Change to a valid ProjectTemplate directory and run cache() again.")

  if (is.null(variable)) return(.cache.status())

  stopifnot(length(variable) == 1)

  CODE <- paste0(deparse(substitute(CODE)), collapse ="\n")
  if (CODE=="NULL") CODE <- NULL

  # strip out comments and newlines from CODE so that changes to those
  # don't force a re-evaluation of CODE unncessarily.

  if (!is.null(CODE)){
    .require.package("formatR")

    CODE <- formatR::tidy_source(text = CODE, comment = FALSE,
                                 blank = FALSE, brace.newline = FALSE,
                                 output = FALSE, width.cutoff = 500)
    CODE <- paste(CODE$text.tidy, sep="", collapse="\n")
  }

  # Check what's already in the cache for variable
  stored <- .read.cache.info(variable)

  # The idea is to only cache if you need to, making scripts faster.
  #
  # cache rules:
  #    - if variable not in cache:
  #              if CODE==NULL & variable in globenv:
  #                          save(variable)
  #                          save(hash(variable))
  #              if CODE==NULL & variable not in globenv:
  #                          error:  variable doesn't exist
  #              Otherwise:
  #                          save(variable=eval(CODE))
  #                          save(hash(variable))
  #                          save(hash(each var in depends))
  #
  #    - if variable in cache:
  #              if CODE==NULL & variable in globenv:
  #                          if hash(globalenv(variable))==hash(cached(variable)):
  #                                   msg:  Skipping caching of variable:  up to date
  #                          Otherwise:
  #                                   save(variable)
  #                                   save(hash(variable))
  #              if CODE==NULL & variable not in globenv:
  #                          msg:  cached variable not updated
  #              Otherwise:
  #                          if hash(eval(CODE))==hash(cached(variable)):
  #                                   msg:  Skipping caching of variable:  up to date
  #                          Otherwise:
  #                                  save(variable=eval(CODE))
  #                                  save(hash(variable))
  #                                  save(hash(each var in depends))
  #
  #
  #  Each code block below either exits early with an appropriate message why the
  #  cache wasn't updated, or the appropriate cache.hash object is created for saving
  #  at the end.
  #  See the .write.cache function for a description of the cache.hash object
  #  which is saved in the cache directory along with the cached variable.

  if (!stored$in.cache) {
    if (is.null(CODE)){
      # genv.hash contains the current hash value from the global env
      # which can be compared to the stored value for variable
      genv.hash <- .create.cache.hash(variable, NULL, NULL)
      if (is.null(genv.hash)) {
        message(paste0("  Cannot cache ", variable,
                       ": Does not exist in global environment and no code to create it"))
        return(invisible(NULL))
      }
      message(paste0("  Creating cache entry from global environment: ", variable))
      cache.hash <- genv.hash
    }
    else {
      message(paste0("  Creating cache entry from CODE: ", variable))
      .evaluate.code(variable, CODE)
      cache.hash <- .create.cache.hash(variable, depends, CODE)
    }
  }
  else {
    if (is.null(CODE)) {
      genv.hash <- .create.cache.hash(variable, NULL, NULL)
      if (is.null(genv.hash)) {
        message(paste0("  Unable to update cache for ", variable,
                       ": Does not exist in global environment and no code to create it"))
        return(invisible(NULL))
      }
      if (stored$hash["VAR",]$hash == genv.hash["VAR",]$hash) {
        message(paste0("  Skipping cache update for ", variable,
                       ": up to date"))
        return(invisible(NULL))
      }
      message(paste0("  Updating existing cache entry from global environment: ", variable))
      cache.hash <- genv.hash
    }
    else {
      genv.hash <- .create.cache.hash(variable, depends, CODE)
      genv.hash <- genv.hash[!grepl("VAR", row.names(genv.hash)),]
      stored.hash <- stored$hash[!grepl("VAR", row.names(stored$hash)),]
      if (isTRUE(all.equal(genv.hash, stored.hash))) {
        message(paste0("  Skipping cache update for ", variable,
                       ": up to date"))
        return(invisible(NULL))
      }
      message(paste0("  Updating existing cache entry from CODE: ", variable))
      .evaluate.code(variable, CODE)
      cache.hash <- .create.cache.hash(variable, depends, CODE)
    }

  }

  # if we end up here then save the variable to the cache
  .write.cache(cache.hash, ...)
}


# Cache directory
.cache.dir <- "cache"

# Possible cache file formats
#
# Each future cache file format must consist of a named expression and be added
# to the list below. This expression in turn must contain four "fields":
# * package: character string naming the required package (don't forget to add
#   it to the list of suggested packages in DESCRIPTION as well)
# * file_ext: character string providing the file extension without leading dot
# * save_expr: expression used to save the file to disk
# * load_expr: expression used to load the file from disk
#
# save_expr and load_expr can make use of the following variables:
# * variable: character string providing the name of the (cached) variable
# * .TargetEnv: environment, in which the variable resides (saving) or has to be
#   assigned to (loading)
# * cache_filename$data: character string providing the full path to the cache
#   file for/of the (cached) variable including its extension
# * ...: additional arguments passed on from the cache to the respective "save"
#   function
.cache.formats <- list(
  RData = expression(
    package = "base",
    file_ext = "RData",
    save_expr = save(list = variable, envir = .TargetEnv, file = cache_filename$data, ...),
    load_expr = load(cache_filename$data, envir = .TargetEnv)
  ),
  qs = expression(
    package = "qs",
    file_ext = "qs",
    save_expr = qs::qsave(get(variable, envir = .TargetEnv), file = cache_filename$data, ...),
    load_expr = assign(variable, qs::qread(cache_filename$data), .TargetEnv)
  )
)

#' Get configured cache file format strategy
#'
#' @return A named object of mode \code{\link{expression}}.
#'
#' @keywords internal
#'
#' @rdname internal.cache.format
.cache.format <- function() {
  if (.has.project()) {
    config <- get.project()$config
  } else {
    config <- suppressWarnings(.load.config())
  }

  if (!config$cache_file_format %in% names(.cache.formats)) {
    stop(
      'Cache file format not available. See "?project.config" for further information.',
      call. = FALSE
    )
  }

  dot <- c(".", "\\.")
  dollar <- c("", "$")
  hash_exts <- sprintf("%shash%s", dot, dollar)

  cache_format <- .cache.formats[[config$cache_file_format]]

  require.package(cache_format[["package"]])

  file_exts <- sprintf("%s%s%s", dot, cache_format[["file_ext"]], dollar)
  if (config$cache_file_format != "RData") {
    hash_exts <- sprintf("%s%s%s", dot, cache_format[["file_ext"]], hash_exts)
  }

  cache_format[["plain_exts"]] <- c(data = file_exts[1], hash = hash_exts[1])
  cache_format[["regex_exts"]] <- c(data = file_exts[2], hash = hash_exts[2])

  cache_format
}

#' Write a variable and its metadata to cache
#'
#' @param cache.hash a \code{data.frame} with metadata about the variable, see details for more information.
#' @param ... extra parameters passed to \code{\link{save}}.
#'
#' @details cache.hash is a data frame with two columns: \code{variable} and \code{hash}.\cr
#'   Row name \code{VAR} is the name of the variable to save.\cr
#'   Row name \code{CODE} is the hash value of the code to compute variable.\cr
#'   Row name \code{DEPENDS.*} are the dependent variables that \code{CODE} depends on.c\cr
#'   The helper function \code{\link{.create.cache.hash}} creates a suitable dataframe
#'
#' @return No value is returned, this function is called for its side effects.
#'
#' @keywords internal
#'
#' @rdname internal.write.cache
.write.cache <- function(cache.hash, ...){
        cache_format <- .cache.format()

        variable <- as.character(cache.hash["VAR",]$variable)
        cache_filename <- .cache.filename(variable, cache_format)

        # cache the variable
        eval(cache_format[["save_expr"]])

        # hash information is stored in a separate file to the data is so
        # it can be retrieved quickly when things need to be read from the cache
        save(list = "cache.hash",
             envir = environment(),
             file = cache_filename$hash
             )
}


#' Create a data.frame with the cache metadata
#'
#' @param variable Name of the variable to be cached
#' @param depends Vector of variable names of dependencies for the variable to be cached, optional.
#' @param CODE Code block to generate \code{variable}, registered as a dependency, optional.
#'
#' @return \code{data.frame} containing the variable name and its dependencies, with the
#'   corresponding hashes appended.
#'
#' @details The hashes for the various objects are calculated using the \code{\link{.cache.hash}}
#'   function.
#'
#' @seealso \code{\link{.cache.hash}}
#'
#' @keywords internal
#'
#' @rdname internal.create.cache.hash
.create.cache.hash <- function(variable, depends, CODE) {
        # This function prepares a cache.hash suitable for
        # saving to the cache
        # It loops through each of the inputs and computes the hash
        # using the .cache.hash helper function

        cache.hash <- .cache.hash(variable)
        if (is.null(cache.hash)) return(NULL)

        row.names(cache.hash) <- "VAR"
        if (!is.null(CODE)){
                code.hash <- .cache.hash("CODE", environment())
                row.names(code.hash) <- "CODE"
                cache.hash <- rbind(cache.hash, code.hash)
        }
        if (!is.null(depends)){
                depends.hash <- .cache.hash(depends)
                if (nrow(depends.hash)>=1) {
                        row.names(depends.hash) <- paste0("DEPENDS.", 1:nrow(depends.hash))
                        cache.hash <- rbind(cache.hash, depends.hash)
                }
        }
        cache.hash
}


#' Calculate the hash of the data stored in a variable
#'
#' @param variables character vector of variable names
#' @param env environment from which to load the variable
#'
#' @details The hashes are calculated using the \code{digest::digest} function.
#'
#' @return data.frame with the variable names and the corresponding hashes
#'
#' @keywords internal
#'
#' @rdname internal.cache.hash
.cache.hash <- function (variables, env=.TargetEnv) {
        # input is a vector of variable names
        # check if they exist in the supplied environment
        # and return a dataframe of their hash values
        .require.package("digest")

        missing <- variables[!sapply(variables, exists, envir=env)]
        if (length(missing)>0){
                return(NULL)
        }


        hashes <- c()
        for (var in variables) {
                hashes <- c(hashes, digest::digest(get(var, envir=env)))
        }

        data.frame(variable=variables, hash=hashes, stringsAsFactors = FALSE)
}


#' Read metadata for a variable in the cache
#'
#' @param variable Variable name for which to look up the metadata
#'
#' @details The returned object is a list with two fields:
#'
#' \itemize{
#'   \item \code{in.cache}: Logical indicating whether the requested
#'     variable was found in the cache
#'   \item \code{hash}: A data.frame as was created by \code{\link{.create.cache.hash}}
#' }
#'
#' @return \code{list} with metadata, see Details for more info.
#'
#' @keywords internal
#'
#' @rdname internal.read.cache.info
.read.cache.info <- function (variable) {

        cache_filename <- .cache.filename(variable, .cache.format())

        in.cache <- FALSE
        if (file.exists(cache_filename$data)) in.cache <- TRUE

        hash <- FALSE
        cache.hash <- NULL
        if (file.exists(cache_filename$hash) & in.cache) {
                # hash data frame will be loaded into cache.hash
                load(cache_filename$hash, envir = environment())
        }

        # If the hash file is missing but the cache file is not, delete
        # the cache object which will force a re-cache with a properly generated
        # hash file.
        if (!file.exists(cache_filename$hash) & in.cache) {
                unlink(cache_filename$data, force=TRUE)
                in.cache <- FALSE
        }

        list(in.cache=in.cache, hash=cache.hash)
}


#' Run code and assign the results to variable
#'
#' @param variable variable name in which to store the result of \code{CODE}
#' @param CODE code block that returns a result which can be stored in a variable
#'
#' @details No error handling is done on the executed code, nor is the
#'
#' @keywords internal
#'
#' @rdname internal.evaluate.code
.evaluate.code <- function (variable, CODE) {
        result <- eval(parse(text=CODE), envir = new.env(parent = .TargetEnv))
        assign(variable, result, envir = .TargetEnv)
}


#' Construct the file names for the cache and hash
#'
#' @param variable Variable name for which to construct file names
#' @param cache_format \code{\link{expression}} as returned by \code{\link{.cache.format}}
#'
#' @details The returned object is a list with two fields:
#' \itemize{
#'   \item \code{data}: The path to the file in which the
#'     variable contents will be saved;
#'   \item \code{hash}: The path to the file in which the cache
#'     metadata will be stored.
#' }
#'
#' @return A list with file names
#'
#' @keywords internal
#'
#' @rdname internal.cache.filename
.cache.filename <- function(variable, cache_format) {
  structure(
    as.list(file.path(.cache.dir, sprintf("%s%s", variable, cache_format[["plain_exts"]]))),
    names = names(cache_format[["plain_exts"]])
  )
}


#' Print the current cache status
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @keywords internal
#'
#' @rdname internal.cache.status
.cache.status <- function () {
        if (.is.cache.empty()) {
                return(message("No variables in cache"))
        }
        status <- ""
        for (var in .cached.variables()) {
                var_info <- .read.cache.info(var)
                status <- paste0(status, "Variable: ", var, "\n")
                if(is.data.frame(var_info$hash)) {
                        code <- var_info$hash[grepl("CODE", row.names(var_info$hash)),]
                        depends <- var_info$hash[grepl("DEPENDS", row.names(var_info$hash)),]
                        if (nrow(code) > 0) {
                                status <- paste0(status, "  Generated from supplied CODE\n")
                        }
                        if (nrow(depends) > 0) {
                          status <- paste0(status, "    Depends on variable: ", depends$variable, "\n")
                        }
                }
                else {
                  status <- paste0(status, "  Incomplete cache record.  Recommend running clear.cache('", var, "') and load.project()\n")
                }

        }
        message(status)
}


#' List all cached variables
#'
#' List all variables for which files are available in the cache. The info is
#' purely based on the files in the \code{cache} directory. There is no
#' guarantee the variable can actually be loaded from the cache.
#'
#' @return Character vector of cached variables
#'
#' @keywords internal
#'
#' @rdname internal.cached.variables
.cached.variables <- function() {
  cache_format <- .cache.format()

  # get all relevant cache files
  cache_files <- list.files("cache", pattern = paste(
    cache_format[["regex_exts"]],
    collapse = "|"
  ))
  # and return the variable names
  unique(sub("^(.*)\\..*$", "\\1", cache_files))
}


#' Check whether variables are cached
#'
#' @param varnames Character vector of variable names
#'
#' @return Logical vector indicating whether the variable is in the cache.
#'
#' @keywords internal
#'
#' @rdname internal.is.cached
.is.cached <- function(varnames) {
  vapply(varnames, function(x){.read.cache.info(x)$in.cache}, logical(1))
}


#' Check whether the cache is empty
#'
#' @return Logical indicating whether the cache is empty
#'
#' @keywords internal
#'
#' @rdname internal.is.cache.empty
.is.cache.empty <- function () {
        cached_variables <- .cached.variables()
        if (length(cached_variables)==0) {
                return(TRUE)
        }
        return(FALSE)
}
