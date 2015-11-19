# getDataFromPostgres.R
#
#

library(RPostgreSQL)
source("~/Code/R-utils-mg/managePostgresConnection.R")

getDataFromPostgres <- function (query = "select * from tv;", creds = as.null()) {
  message("Opening connection...")
  pg <- connectToPostgres(creds)
  con <- pg[[2]]
  #query <- "select * from tv;"
  
  message("Running query...")
  print( paste("Started at:", Sys.time() ) )
  pt <- proc.time()
  df <- dbGetQuery(con, query)
  message("Query complete.")
  print(proc.time() - pt)
  
  closePostgresConnection(con)
  message("Connection closed.")
  
  return(df)
}



