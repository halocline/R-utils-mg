## manageMongoConnection.R
## by mdglissmann@gmail.com
## July 2015

library(rmongodb)
source("./lib/R_utils_mg/getCredentials.R")

closeMongoConnection <- function (m) {
  mongo.destroy(m)
  if (mongo.is.connected(m) == FALSE) {
    message("... connection ended.")
  }
}

connectToMongo <- function () {
  message("Enter credentials for MongoDB ...")
  creds <- getCredentials()
  m <- mongo.create(username = creds[1], password = creds[2])
  
  if (mongo.is.connected(m) == TRUE) {
    message("... connection successful.")
  }
  #else {
  #  message("... failed to connect. Exiting...")
  #}
  
  return(m)
}