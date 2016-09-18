#' Cache a data set for faster loading.
#'
#' This function will store a copy of the named data set in the \code{cache}
#' directory. This cached copy of the data set will then be given precedence
#' at load time when calling \code{\link{load.project}}. Cached data sets are
#' stored as \code{.RData} files.
#' 
#' Sometimes it can take a while to cache large variables, which causes 
#' \code{load.project()} to run slowly if values are cached during munging.  If the
#' \code{always} variable is set to \code{FALSE}, then caching is skipped if the 
#' variable is already in the cache.  The \code{clear.cache("variable")} command
#' can be run to flush individual items from the cache.
#'
#' @param variable A character string containing the name of the variable to
#'  be saved.  If the CODE parameter is defined, it is evaluated and saved, otherwise
#'  the variable with that name in the global environment is used.
#' @param CODE A sequence of R statements enclosed in {..} which produce the object to be
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
cache <- function(variable, depends=NULL, CODE=NULL, ...)
{
  stopifnot(length(variable) == 1)
  
  
  cache <- .read.cache.info(variable)
  
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
  #                      

  if (!is.null(CODE)) {
          assign(variable, CODE, envir=.TargetEnv)
  }
  
  
  
}


.in.globalenv <- function(variable){
        exists(variable, envir = .TargetEnv)
}

.write.cache <- function(variable.hash, ...){
        # variable.hash is a data frame with two columns:  variable and hash.
        # Row name VAR is the name of the variable to save.
        # Row name CODE is the hash value of the code to compute variable.
        # Row name DEPENDS.* are the dependent variables that CODE depends on.
        # The helper function .create.variable.hash creates a suitable dataframe
        
        variable <- as.character(variable.hash["VAR",]$variable)
        cache_filename <- .cache.filename(variable)
        
        # cache the variable
        save(list = variable,
             envir = .TargetEnv,
             file = cache_filename$obj,
             ...)
        
        # hash information is stored in a separate file to the data is so
        # it can be retrieved quickly when things need to be read from the cache
        save(list = "variable.hash",
             envir = environment(),
             file = cache_filename$hash
             )
}

.create.variable.hash <- function(variable, depends, CODE) {
        # This function prepares a variable.hash suitable for
        # saving to the cache
        # It loops through each of the inputs and computes the hash
        # using the .variable.hash helper function
        
        variable.hash <- .variable.hash(variable)
        row.names(variable.hash) <- "VAR"
        if (!is.null(CODE)){
                code.hash <- .variable.hash("CODE", environment())
                row.names(code.hash) <- "CODE"
                variable.hash <- rbind(variable.hash, code.hash)
        }
        if (!is.null(depends)){
                depends.hash <- .variable.hash(depends)
                row.names(depends.hash) <- paste0("DEPENDS.", 1:nrow(depends.hash))
                variable.hash <- rbind(variable.hash, depends.hash)
        }
        variable.hash
}


.variable.hash <- function (variables, env=.TargetEnv) {
        # input is a vector of variable names  
        # check if they exist in the supplied environment
        # and return a dataframe of their hash values
        .require.package("digest")
        variables <- variables[sapply(variables, exists, envir=env)]
        hashes <- c()
        for (var in variables) {
                hashes <- c(hashes, digest(get(var, envir=env)))
        }
        
        data.frame(variable=variables, hash=hashes)
}


.read.cache.info <- function (variable) {
        
        cache_name <- .cache.filename(variable)
        
        in.cache <- FALSE
        if (file.exists(cache_name$obj)) in.cache <- TRUE
        
        hash <- FALSE
        variable.hash <- NULL
        if (file.exists(cache_name$hash) & in.cache) {
                # hash data frame will be loaded into variable.hash
                load(cache_name$hash, envir = environment())
        }
        
        list(in.cache=in.cache, hash=variable.hash)
}



#' Check whether a variable is in the cache
#'
#' This function will determine if a variable is stored in the \code{cache}
#' directory. 
#' 
#' @param variable A character string containing the name of the variable to
#'  be checked.
#' 
#' @return \code{TRUE} if the variable exists in the cache, \code{FALSE} otherwise
#'
#' @export
#' @examples
#' library('ProjectTemplate')
#' \dontrun{is.cached('mapdata')
#' }
is.cached <- function(variable)
{
  stopifnot(length(variable) == 1)
  if (file.exists(.cache.file(variable))) return (TRUE)
  return (FALSE)
}

.cache.filename <- function(variable) {
        list(
                obj=file.path('cache', paste0(variable, '.RData')),
                hash=file.path('cache', paste0(variable, '.hash'))
        )
}
