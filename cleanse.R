## cleanse.R
## by mdglissmann@gmail.com
## July 2015

colnamesRemoveWhitespace <- function (dt) {
  cols <- colnames(dt)
  
  for ( i in 1:length(cols) ) {
    setnames(dt, cols[i], gsub(" ", "_", cols[i]) )
  }
  
  return(dt)
}

colnamesToLower <- function (dt) {
  cols <- colnames(dt)
  
  for ( i in 1:length(cols) ) {
    setnames(dt, cols[i], tolower(cols[i]) ) 
  }
  
  return(dt)
}

colsFactorsToChars <- function (dt) {
  dt <- as.data.frame(dt)
  
  dt[ sapply(dt, is.factor) ] <- lapply(
    dt[ sapply(dt, is.factor) ],
    as.character
  )
  
  dt <- as.data.table(dt)
  return(dt)
}



