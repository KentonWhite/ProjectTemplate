db.reader <- function(data.file, filename, variable.name)
{
  # Read all tables from a SQLite3 database file.
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
