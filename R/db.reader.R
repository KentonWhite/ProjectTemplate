#' @describeIn preinstalled.readers Read a SQlite3 database with a \code{.db} file extension.
#'
#' If you want to specify a single table or query to execute against the database,
#' move it elsewhere and use a .sql file interpreted by \code{\link{sql.reader}}.
db.reader <- function(data.file, filename, variable.name)
{
  .require.package('RSQLite')

  sqlite.driver <- DBI::dbDriver("SQLite")
  connection <- DBI::dbConnect(sqlite.driver,
                          dbname = filename)
  on.exit(try(DBI::dbDisconnect(connection), silent = TRUE), add = TRUE)

  tables <- DBI::dbListTables(connection)
  for (table in tables)
  {
    message(paste('  Loading table:', table))

    data.parcel <- DBI::dbReadTable(connection,
                               table,
                               row.names = NULL)

    assign(clean.variable.name(table),
           data.parcel,
           envir = .TargetEnv)
  }
}
