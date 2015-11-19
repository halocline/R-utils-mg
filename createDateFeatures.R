## createDateFeatures.R
## written by mdglissmann@gmail.com
## September 2015
##

#require(Hmisc)
source("~/Code/R-utils-mg/merge.with.order.R")
require(timeDate)

createDateTimeFeatures <- function (date_times) {
  x <- date_times
  if ( is.POSIXct(x) == FALSE ) {
    warning("Function input must be class POSIXct. Exiting.")
    return()
  }
  features <- as.data.frame(x)
  colnames(features)[1] <- "date_time"
  
  ## Day parts
  hour_of_day <- format(x, "%H")
  features$hour_of_day <- hour_of_day
  minute_in_hour <- format(x, "%M")
  features$minute_in_hour <- minute_in_hour
  daypart <- getDaypart(x)
  features$daypart <- daypart
  
  ## Date parts
  day_of_week <- format(x, "%w") ## 0 = Sunday
  features$day_of_week <- day_of_week
  day_in_month <- format(x, "%d")
  features$day_in_month <- day_in_month
  #day_in_quarter
  day_in_year <- format(x, "%j")
  features$day_in_year <- day_in_year
  weekday <- isWeekday(x, wday = 1:5) * 1
  features$weekday <- weekday
  weekend <- isWeekend(x, wday = 1:5) * 1
  features$weekend <- weekend
  #week_in_month
  #week_in_quarter
  week_in_year <- as.numeric(format(x, "%W")) ## Use %W for weeks beginning on Mondays.  Use %U for weeks beginning on Sundays.
  features$week_in_year <- week_in_year
  month_in_quarter <- as.character( as.numeric( format(x, "%m") ) %% 3 )
  month_in_quarter[month_in_quarter == "0"] <- "3"
  features$month_in_quarter <- as.numeric(month_in_quarter)
  month_in_year <- as.numeric(format(x, "%m"))
  features$month_in_year <- month_in_year
  quarter_in_year <- as.numeric(substr(quarters(x), nchar(quarters(x)), nchar(quarters(x))))
  features$quarter_in_year <- quarter_in_year
  ## Season
  #season_traditional
  #season_usage
  
  ## Holidays
  holidays <- c("ChristmasDay", "USThanksgivingDay", "USElectionDay", "USLaborDay",
    "USIndependenceDay", "USMemorialDay", "Easter", "USPresidentsDay",
    "USMLKingsBirthday" , "USNewYearsDay"
  )
  holidays.major <- c("ChristmasDay", "USThanksgivingDay", "USIndependenceDay",
    "USNewYearsDay"
  )
  holidays.minor <- c("USElectionDay", "USLaborDay", "USMemorialDay", "Easter",
    "USPresidentsDay", "USMLKingsBirthday"
  )
  holiday <- checkHolidays(x, holidays)
  features$holiday <- holiday
  holiday_major <- checkHolidays(x, holidays.major)
  features$holiday_major <- holiday_major
  holiday_minor <- checkHolidays(x, holidays.minor)
  features$holiday_minor <- holiday_minor
  holiday_christmas <- checkHoliday(x, "ChristmasDay")
  features$holiday_christmas <- holiday_christmas
  holiday_thanksgiving <- checkHoliday(x, "USThanksgivingDay")
  features$holiday_thanksgiving <- holiday_thanksgiving
  holiday_election_day <- checkHoliday(x, "USElectionDay")
  features$holiday_election_day <- holiday_election_day
  holiday_labor_day <- checkHoliday(x, "USLaborDay")
  features$holiday_labor_day <- holiday_labor_day
  holiday_july4 <- checkHoliday(x, "USIndependenceDay")
  features$holiday_july4 <- holiday_july4
  holiday_memorial_day <- checkHoliday(x, "USMemorialDay")
  features$holiday_memorial_day <- holiday_memorial_day
  holiday_easter <- checkHoliday(x, "Easter")
  features$holiday_easter <- holiday_easter
  holiday_presidents_day <- checkHoliday(x, "USPresidentsDay")
  features$holiday_presidents_day <- holiday_presidents_day
  holiday_mlk <- checkHoliday(x, "USMLKingsBirthday")
  features$holiday_mlk <- holiday_mlk
  holiday_new_years_day <- checkHoliday(x, "USNewYearsDay")
  features$holiday_new_years_day <- holiday_new_years_day
  
  holiday_week_christmas <- checkHolidayWeek(x, "ChristmasDay")
  features$holiday_week_christmas <- holiday_week_christmas
  holiday_week_new_years <- checkHolidayWeek(x, "USNewYearsDay")
  features$holiday_week_new_years <- holiday_week_new_years
  holiday_week_thanksgiving <- checkHolidayWeek(x, "USThanksgivingDay")
  features$holiday_week_thanksgiving <- holiday_week_thanksgiving
  holiday_week_july4 <- checkHolidayWeek(x, "USIndependenceDay")
  features$holiday_week_july4 <- holiday_week_july4
  features$holiday_week <- rowSums(features[,c("holiday_week_christmas",
    "holiday_week_new_years", "holiday_week_thanksgiving", "holiday_week_july4")
    ])
  
  ## Open for business
  #business_hours
  #call_center_hours
  #assign("features", features, envir = .GlobalEnv)
  return(features)
}

checkHoliday <- function(x, holiday) {
  require(timeDate)
  years <- as.numeric( format(x, "%Y") )
  dates <- as.character( as.Date(x, format = "%Y-%m-%d") )
  tmp <- as.character(holiday(years, Holiday = holiday))
  holidays <- tmp == dates
  holidays <- holidays * 1
  return(holidays)
}

checkHolidays <- function(x, holidays) {
  require(timeDate)
  years <- as.numeric( format(x, "%Y") )
  dates <- as.character( as.Date(x, format = "%Y-%m-%d") )
  tmp <- as.data.frame(dates)
  for (i in 1:length(holidays)) {
    y <- as.character(holiday(years, Holiday = holidays[i]))
    y <- y == dates
    tmp[,i+1] <- y
    colnames(tmp)[i+1] <- holidays[i]
  }
  tmp[,1:length(holidays)+1] <- tmp[,1:length(holidays)+1] * 1
  tmp$holiday <- rowSums(tmp[,1:length(holidays)+1])
  return(tmp$holiday)
}

checkHolidayWeek <- function(x, holiday) {
  require(timeDate)
  years <- as.numeric( format(x, "%Y") )
  dates <- as.Date(x, format = "%Y-%m-%d")
  tmp <- holiday(years, Holiday = holiday)
  dates <- format(dates, "%W")
  tmp <- format(tmp, "%W")
  holidays <- tmp == dates
  holidays <- holidays * 1
  return(holidays)
}

getDaypart <- function (x) {
  hour <- as.data.frame(format(x, "%H"), stringsAsFactors = FALSE)
  colnames(hour) <- "hour"
  dayparts <- data.frame(
    hour = c("00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10",
             "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21",
             "22", "23"),
    daypart = c("0", "0", "0", "0", "1", "1", "1", "1", "2", "2", "2", "2",
                "3", "3", "3", "3", "4", "4", "4", "4", "5", "5", "5", "5"),
    stringsAsFactors = FALSE
  )
  daypart <- merge.with.order(hour, dayparts, by = "hour", all.x = TRUE, sort = T, keep_order = 1)
  daypart <- daypart$daypart
  if ( length(daypart) == length(x) ) {
    return(daypart)
  }
  else {
    warning("Input and output lengths do not match. Exiting.")
    return()
  }
}

is.POSIXct <- function (x) inherits(x, "POSIXct")
