library(RPostgreSQL)

connectToPostgres <- function () {
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv, host = "localhost", dbname = "pocmmm", user = "mglissmann", password = "eddieV26")
  return <- list(drv, con)
}

closePostgresConnection <- function(con, drv) {
  dbDisconnect(con)
  #dbUnloadDriver(drv)   ## Frees all the resources on the driver
}

#dbListConnections(drv)
#dbGetInfo(drv)
#summary(con)
#dbListResults(conn = con)
#dbListTables(con)
