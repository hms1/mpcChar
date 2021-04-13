IncidencePC <- function(connection,
                        cdmDatabaseSchema,
                        vocabularyDatabaseSchema = cdmDatabaseSchema,
                        cohortDatabaseSchema,
                        cohortTable,
                        oracleTempSchema,
                        outputFolder) {


  # Fetch Counts by Year:
  #Execute
  sql <- SqlRender::render(SqlRender::readSql(system.file("sql", "sql_server", "IncidencePC.sql", package = "determinePC")),
                           cohort_database_schema = cohortDatabaseSchema,
                           cohort_table = cohortTable)
  sql <- SqlRender::translate(sql, targetDialect = attr(connection, "dbms"))
  DatabaseConnector::executeSql(connection, sql)

  #Query
  sql <- "SELECT * FROM #incidence_tmp"
  sql <- SqlRender::render(sql,
                           cohort_database_schema = cohortDatabaseSchema,
                           cohort_table = cohortTable)
  sql <- SqlRender::translate(sql, targetDialect = attr(connection, "dbms"))

  DatabaseConnector::querySql(connection, sql)

}
