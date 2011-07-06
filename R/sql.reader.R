#' Read a database described in a .sql file.
#'
#' This function will load data from a SQL database based on configuration
#' information found in the specified .sql file. The .sql file must specify
#' a database to be accessed. All tables from the database, one specific tables
#' or one specific query against any set of tables may be executed to generate
#' a data set.
#'
#' Examples of the DCF format and settings used in a .sql file are shown
#' below:
#'
#' Example 1
#' type: mysql
#' user: sample_user
#' password: sample_password
#' host: localhost
#' dbname: sample_database
#' table: sample_table
#'
#' Example 2
#' type: sqlite
#' dbname: /path/to/sample_database
#' table: sample_table
#'
#' Example 3
#' type: sqlite
#' dbname: /path/to/sample_database
#' query: SELECT * FROM users WHERE user_active == 1
#'
#' Example 4
#' type: sqlite
#' dbname: /path/to/sample_database
#' table: *
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
#' #sql.reader('example.sql', 'data/example.sql', 'example')
sql.reader <- function(data.file, filename, variable.name)
{
  database.info <- ProjectTemplate:::translate.dcf(filename)

  if (! (database.info[['type']] %in% c('mysql', 'sqlite', 'odbc')))
  {
    warning('Only databases reachable through RMySQL, RSQLite and RODBC are currently supported.')
    assign(variable.name,
           NULL,
           envir = .GlobalEnv)
    return()
  }

  # Draft code for ODBC support.
  if (database.info[['type']] == 'odbc')
  {
    library('RODBC')
    connection <- odbcConnect(database.info[['dbname']])
    sqlQuery(connection, database.info[['query']])
    results <- sqlGetResults(connection, as.is = TRUE)
    odbcClose(connection)
    assign(variable.name,
           results,
           envir = .GlobalEnv)
  }
  
  if (database.info[['type']] == 'mysql')
  {
    library('RMySQL')
    mysql.driver <- dbDriver("MySQL")

    connection <- dbConnect(mysql.driver,
                            user = database.info[['user']],
                            password = database.info[['password']],
                            host = database.info[['host']],
                            dbname = database.info[['dbname']])
  }

  if (database.info[['type']] == 'sqlite')
  {
    library('RSQLite')
    sqlite.driver <- dbDriver("SQLite")

    connection <- dbConnect(sqlite.driver,
                            dbname = database.info[['dbname']])
  }

  # Added support for queries.
  # User should specify either a table name or a query to execute, but not both.
  table <- database.info[['table']]
  query <- database.info[['query']]
  
  # If both a table and a query are specified, favor the query.
  if (! is.null(table) && ! is.null(query))
  {
      warning(paste("'query' parameter in ",
                    filename,
                    " overrides 'table' parameter.",
                    sep = ''))
      table <- NULL
  }

  if (is.null(table) && is.null(query))
  {
    warning("Either 'table' or 'query' must be specified in a .sql file")
    return()
  }
  
  if (! is.null(table) && table == '*')
  {
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
  }
  
  # If table is specified, read the whole table.
  # Othwrwise, execute the specified query.
  if (! is.null(table) && table != '*')
  {
    if (dbExistsTable(connection, table))
    {
      data.parcel <- dbReadTable(connection,
                                 table,
                                 row.names = NULL)
      
      assign(variable.name,
             data.parcel,
             envir = .GlobalEnv)
    }
    else
    {
      warning(paste('Table not found:', table))
      return()
    }
  }

  if (! is.null(query))
  {
    data.parcel <- try(dbGetQuery(connection, query))
    err <- dbGetException(connection)
    
    if (class(data.parcel) == 'data.frame' && err$errorNum == 0)
    {
      assign(variable.name,
             data.parcel,
             envir = .GlobalEnv)
    }
    else
    {
      warning(paste("Error loading '",
                    variable.name,
                    "' with query '",
                    query,
                    "'\n    '",
                    err$errorNum,
                    "-",
                    err$errorMsg,
                    "'",
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

  # Disconnect from database resources. Warn if failure.
  disconnect.success <- dbDisconnect(connection)

  if (! disconnect.success)
  {
    warning(paste('Unable to disconnect from database:',
                  database.info[['dbname']]))
  }
}
