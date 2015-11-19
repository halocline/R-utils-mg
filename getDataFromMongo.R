## getDataFromMongo.R
## by mdglissmann@gmail.com
## July 2015

library(rmongodb)
#source("./lib/manageMongoConnection.R")
source("~/Code/R-utils-mg/manageMongoConnection.R")

getDataFromMongo <- function () {
  m <- connectToMongo()
  assign("m", m, envir = .GlobalEnv)
  db <- "pocmmm"
  ns <- "pocmmm.measures"
  
  ### Have user select which measure and timeframe they would like to add to their data set
  params <- getQueryParams(m, ns)
  
  ### Get data from database
  l <- lapply(params$vars, function (x) {
    y <- queryMongo(m, ns, x, params$dates[1], params$dates[2])
    #y <- queryMongo2(m, ns, x, params$dates[1], params$dates[2])
    y
  })
  closeMongoConnection(m)
  return(l)
}

getQueryParams <- function (m, ns) {
  if ( mongo.is.connected(m) == TRUE ) {
    vars <- list()
    while ( length(vars) == 0 || vars[[length(vars)]] != 0 ) {
      message("Available measures: ")
      measure_opts <- listMeasures(m, ns, key = "variable")
      print(measure_opts)
      var <- readline("Which measure do you want to add to your analysis? Enter 0 when desired measures have been selected: ")
      vars <- append(vars, var)
    }
    vars <- vars[1:( length(vars) - 1 )]
    
    ## present user with timeframe
    ## have user select timeframe
    dt_begin <- readline("Enter begin date in YYYY-MM-DD format: ")
    dt_end <- readline("Enter begin date in YYYY-MM-DD format: ")
    l <- list(vars=vars, dates=c(dt_begin, dt_end))
    return(l)
  }
}

queryMongo <- function (m, ns, var, begin, end) {
  print( paste("Started at:", Sys.time()) )
  pt <- proc.time()
  l <- mongo.find.all(
    m,
    ns,
    query = paste(
      '{ "variable": "', var, '", "date": { "$gte": "', begin, '", "$lt": "', end, '" } }',
      sep = ""
    )
    #, fields = '{ "variable": 1, "value": 1, "week_begin": 1, "date": 1, "hour": 1, "minute": 1, "day_of_week": 1, "daypart": 1, "" }'
  )
  print( paste("Completed at:", Sys.time()) )
  print( proc.time() - pt )
  return(l)
}

queryMongo2 <- function (m, ns, var, begin, end) {
  print( paste("Started at:", Sys.time()) )
  pt <- proc.time()
  l <- mongo.find(
    m,
    ns,
    query = paste(
      '{ "variable": "', var, '", "date": { "$gte": "', begin, '", "$lt": "', end, '" } }',
      sep = ""
    )
    #, fields = '{ "variable": 1, "value": 1, "week_begin": 1, "date": 1, "hour": 1, "minute": 1, "day_of_week": 1, "daypart": 1, "" }'
  )
  print( paste("Completed at:", Sys.time()) )
  print( proc.time() - pt )
  return(l)
}

getCollections <- function (m, db) {
  collections <- mongo.get.database.collections(m, db)
}

listMeasures <- function (m, ns, key = "variable") {
  mongo.distinct(m, ns, key)
}

listDatabases <- function (m) {
  mongo.get.databases(m)
}

listCollections <- function (m, db) {
  mongo.get.database.collections(m, db)
}




