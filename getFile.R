## getFile.R
## written by mdglissmann@gmail.com
## February 2015

library(data.table)

getFile <- function(path, sep = ",") {
  dt <- fread(input = path, nrows = -1L, skip = 0, sep = sep)
  return(dt)
}

getFiles <- function(dir, files, sep = "") {
  for ( i in 1:length(files) ) {
    path.tmp <- paste(dir, "/", files[i], sep = "")
    if ( !exists("x") ) {
      x <- getFile(path.tmp, sep = sep)
    }
    else {
      y <- getFile(path.tmp, sep = sep)
      x <- rbind(x, y)
      rm(y)
    }
  }
  return(x)
}

unzip <- function (path) {
    #path <- gsub(" ", "\\\\ ", path)
    #system( paste("tar -zxvf", path))
    #path <- gsub(".tar.gz", "", path)
    contents <- untar(path, list = TRUE, exdir = "./tmp", verbose = TRUE)
    untar(path, list = FALSE, exdir = "./tmp", verbose = TRUE)
    dir <- list.dirs(path = "./tmp")
    return(dir)
}

getFiles <- function(dir, files, sep = "") {
  for ( i in 1:length(files) ) {
    path.tmp <- paste(dir, "/", files[i], sep = "")
    if ( !exists("x") ) {
      x <- getFile(path.tmp, sep = sep)
    }
    else {
      y <- getFile(path.tmp, sep = sep)
      x <- rbind(x, y)
      rm(y)
    }
  }
  return(x)
}