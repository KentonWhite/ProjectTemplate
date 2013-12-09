#' Read an ElasticSearch index described in a .es file.
#'
#' This function will load data from an ElasticSearch index based on configuration
#' information found in the specified .es file. The .es file must specify
#' an ElasticSearch sercer to be accessed. A specific query against any index may be executed to generate
#' a data set.
#'
#' Example of the DCF format and settings used in a .es file are shown
#' below:
#'
#' host: localhost
#' port: 9200
#' index: sample_index
#' field: text
#' query: this AND that
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{es.reader('example.es', 'data/example.es', 'example')}
es.reader <- function(data.file, filename, variable.name)
{
  server.info <- ProjectTemplate:::translate.dcf(filename)

  library('RElasticSearch')
  
  # Default value for 'port' in RElasticSearch is 9200L.
  if (is.null(server.info[['port']]))
  {
    server.info[['port']] <- 9200
  }
  
  server <- new('ElasticSearchServer', 
                     	host = server.info[['host']],
                      port = as.integer(server.info[['port']])
									)
									
  index <- new('ElasticSearchServerIndex', server=server, index = server.info[['index']])

  query <- server.info[['query']]
  field <- server.info[['field']]
	
  if (is.null(query))
  {
    warning("'query' must be specified in a .es file")
    return()
  }
  
  if (is.null(field))
  {
    warning("'field' must be specified in a .es file")
    return()
  }

  if (! is.null(query) && ! is.null(field))
  {
    data.parcel <- try(query(index, query_string = list(default_field = field, query = query)))
		
		if (class(data.parcel) == 'AsIs') 
		{
			warning(paste(query, ' returned empty result.', sep=''))
			return()
		}

		if (class(data.parcel) == 'list')
    {
		
			# structure is a list of lists
			# Convert to DataFrame
		
			# Store names for later
			names = names(data.parcel[[1]])
			names = gsub('^_', '', names)
		
			data.parcel = as.data.frame(matrix(unlist(data.parcel), ncol=length(names), byrow = TRUE))
			names(data.parcel) = names
		
	    assign(variable.name,
	           data.parcel,
	           envir = .GlobalEnv)
    }
		
    else
    {
      warning(paste("Error loading '",
                    variable.name,
                    "' with query '",
                    query, "'.",
                    sep = ''))
      return()
    }
  }

  # If the table exists but is empty, do not create a variable.
  # Or if the query returned no results, do not create a variable.
  if (nrow(data.parcel) == 0)
  {
    assign(variable.name,
           NULL,
           envir = .GlobalEnv)
    return()
  }

}
