## global.R ##
library(shinydashboard)
library(shiny)
library(dplyr)
library(lubridate)
library(googleVis)
library(ggplot2)
library(DT)
library(leaflet)


NYC_Daycare = read.csv('./data/DOHMH_Childcare_Center_Inspections.csv',
                       stringsAsFactors = F)


NYC_Daycare$Full.Address = paste0(NYC_Daycare$Building, " ", NYC_Daycare$Street, " ", NYC_Daycare$Borough, " ", NYC_Daycare$ZipCode) 


clean_date_str <- function( date_str ){
  require( lubridate )
  parse_date_time( date_str, orders = c('mdY','mdy') )
}

