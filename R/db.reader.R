#' Read a SQlite3 database with a (.db) file extension.
#'
#' This function will load all of the data sets stored in the SQlite3
#' database into the global environment. If you want to specify a single
#' table or query to execute against the database, move it elsewhere and
#' use a .sql file interpreted by \code{\link{sql.reader}}.
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
#' \dontrun{db.reader('example.db', 'data/example.db', 'example')}
db.reader <- function(data.file, filename, variable.name)
{
  library('RSQLite')
  sqlite.driver <- dbDriver("SQLite")
  connection <- dbConnect(sqlite.driver,
                          dbname = filename)
  
  tables <- dbListTables(connection)
  for (table in tables)
  {
    message(paste('  Loading table:', table))
    
    data.parcel <- dbReadTable(connection,
	                             table,
	                             row.names = NULL)
	  
	  assign(ProjectTemplate:::clean.variable.name(table),
	         data.parcel,
	         envir = .GlobalEnv)
  }

  disconnect.success <- dbDisconnect(connection)
  if (! disconnect.success)
  {
    warning(paste('Unable to disconnect from database:', filename))
  }
}
