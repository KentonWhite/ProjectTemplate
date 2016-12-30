#' Cache a data set for faster loading.
#'
#' This function will store a copy of the named data set in the \code{cache}
#' directory. This cached copy of the data set will then be given precedence
#' at load time when calling \code{\link{load.project}}. Cached data sets are
#' stored as \code{.RData} files.
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
#' @param ... additional arguments passed to \code{\link{save}}
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


# Cache directory and extension used

.cache.dir <- 'cache'
.cache.file.ext <- '.RData'

# Function to save to cache

.write.cache <- function(cache.hash, ...){
        # cache.hash is a data frame with two columns:  variable and hash.
        # Row name VAR is the name of the variable to save.
        # Row name CODE is the hash value of the code to compute variable.
        # Row name DEPENDS.* are the dependent variables that CODE depends on.
        # The helper function .create.cache.hash creates a suitable dataframe
        
        variable <- as.character(cache.hash["VAR",]$variable)
        cache_filename <- .cache.filename(variable)
        
        # cache the variable
        save(list = variable,
             envir = .TargetEnv,
             file = cache_filename$obj,
             ...)
        
        # hash information is stored in a separate file to the data is so
        # it can be retrieved quickly when things need to be read from the cache
        save(list = "cache.hash",
             envir = environment(),
             file = cache_filename$hash
             )
}

# Function to load all items from the cache
# Returns a list of files actually loaded from the cache

.load.cache <- function() {
        
        # Get all cached files (hash file not needed for load)
        cache.files <- list.files(.cache.dir, pattern = .cache.file.ext,
                                  full.names = TRUE)
        global_env_vars <- ls(envir = .TargetEnv)
        
        cached.files <- c()
        
        for (cache.file in cache.files) {
                
                variable.name <- gsub(.cache.file.ext,'',basename(cache.file))
                
                # If this variable already exists in the global environment, don't load
                # it from cache.
                if (variable.name %in% global_env_vars)
                        next()
                
                message(paste(" Loading cached data set: ", variable.name, sep = ''))
                
                load(cache.file, envir = .TargetEnv)
                
                cached.files <- c(cached.files, variable.name)
        }
        
        cached.files
}


# Helper functions to create cache entries

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


.read.cache.info <- function (variable) {
        
        cache_name <- .cache.filename(variable)
        
        in.cache <- FALSE
        if (file.exists(cache_name$obj)) in.cache <- TRUE
        
        hash <- FALSE
        cache.hash <- NULL
        if (file.exists(cache_name$hash) & in.cache) {
                # hash data frame will be loaded into cache.hash
                load(cache_name$hash, envir = environment())
        }
        
        list(in.cache=in.cache, hash=cache.hash)
}

.evaluate.code <- function (variable, CODE) {
        # run code and assignthe results to variable in the global env
        result <- eval(parse(text=CODE), envir = new.env())
        assign(variable, result, envir = .TargetEnv)
}


.cache.filename <- function(variable) {
        list(
                obj=file.path(.cache.dir, paste0(variable, .cache.file.ext)),
                hash=file.path(.cache.dir, paste0(variable, '.hash'))
        )
}

.cache.status <- function () {
        cached_variables <- .cached.variables()
        if (length(cached_variables)==0) {
                return(message("No variables in cache"))
        }
        status <- ""
        for (var in cached_variables) {
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

.cached.variables <- function(){
        # get all relevant cache files
        cache_files <- list.files("cache", pattern="\\.(RData|hash)$")
        # and return the variable names
        unique(sub("^(.*)\\..*$", "\\1", cache_files))
}

