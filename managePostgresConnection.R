## managePostgresConnection.R
## written by mdglissmann@gmail.com
## August 2015

library(RPostgreSQL)
#setwd("~/Code/R-utils-mg/")
source("~/Code/R-utils-mg/getCredentials.R")

connectToPostgres <- function (creds = as.null()) {
  drv <- dbDriver("PostgreSQL")
  if ( is.null(creds) == TRUE ) {
    creds <- getCredentialsDB()
  }
  con <- dbConnect(drv, host = creds[1], dbname = creds[2], user = creds[3], password = creds[4])
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
