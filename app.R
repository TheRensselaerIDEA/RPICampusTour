# This is the main app.R
library(shiny)
library(leaflet)
library(tidyverse)
library(ggplot2)
#library(useful)

# Read in the tour location data
# TODO: Make this a Google spreadsheet...
tour_locations <<- read_csv("~/data/CampfireShiny/CampusTour/tour_locations.csv")

source("campfire_lib.R")

campfireApp(
  
  controller = div(
    h1("Controller")
  ),
  
  wall = div(
    uiOutput("wall_ui")
  ),
  
  leftmonitor = div(
    uiOutput("left_ui")
  ),
  
  
  floor = div(
    fluidPage(
      fluidRow(
        leafletMap(
          "map", "100%", 1000,
          options=list(
            center = c(mean(tour_locations$latitude), mean(tour_locations$longitude)),
            zoom = 16,
            maxBounds = list(list(17, -180), list(59, 180)))))
      )),

  serverFunct = function(serverValues, output, session) {
    
    map = createLeafletMap(session, 'map')
    session$onFlushed(once=T, function(){
      
    map$addCircleMarker(lat = tour_locations$latitude, 
                        lng = tour_locations$longitude, 
                        radius = tour_locations$radius, 
                        layerId = tour_locations$ids)
    })        
    
    output$wall_ui <- renderUI({
      fluidPage(
        htmlOutput("frame")
      )    
    })
    
    output$frame <- renderUI({
      if(!is.null(serverValues$url)) {
        includeHTML(serverValues$url)
#        redirectScript <- paste0("window = window.open('", serverValues$url, "');")
#        tags$script(HTML(redirectScript))
      } else {
        includeHTML("http://orion.tw.rpi.edu/~olyerickson/rpi_logo_wall_2.html")
#        redirectScript <- paste0("window = window.open('", "http://orion.tw.rpi.edu/~olyerickson/rpi_logo_wall.html", "');")
#        tags$script(HTML(redirectScript))
      }
    })

    output$left_ui <- renderUI({
      fluidPage(
        htmlOutput("frame_left")
      )    
    })
    
    output$frame_left <- renderUI({
      if(!is.null(serverValues$text)) {
        redirectScript <- paste0("window = window.open('", serverValues$text, "');")
        tags$script(HTML(redirectScript))
      } else {
        redirectScript <- paste0("window = window.open('", "http://rpi.edu", "');")
        tags$script(HTML(redirectScript))
      }
    })
    
  }
)
