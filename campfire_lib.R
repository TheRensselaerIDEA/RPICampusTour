# MW Shiny ----------------------------------------------------------------

campfireApp = function(controller = NA, wall = NA, floor = NA, leftmonitor = NA,
                       rightmonitor = NA, serverFunct = NA) {
  
  
  ui <- campfireUI(controller, wall, floor, leftmonitor, rightmonitor)
  
  # MW Shiny central reactive values. initialized makes sure default search is done on startup.
  # Some of these are TTM specific and should be deleted...
  serverValues <- reactiveValues(initialized = FALSE,
                                 data_subset = NULL,
                                 type = "none",
                                 current_node_id = -1,
                                 current_node_index = -1)
  
  campfire_server <- shinyServer(function(input, output, session) {
    
    # Observe when points on the map are clicked
    observeEvent(input$map_marker_click, {
      # Determine what was clicked on the map
      #
      click<-input$map_marker_click
      if(is.null(click))
        return()
      # url of page providing Wall content (from dataframe)
      serverValues$url <- tour_locations$urls[which(tour_locations$ids == click$id)]
      # url of page providing left external monitor content (from dataframe)
      serverValues$text <- tour_locations$tour_text[which(tour_locations$ids == click$id)]
      
  })
    
    serverFunct(serverValues, output, session)
    
  })
  
  shinyApp(ui, server = campfire_server)
}

campfireUI = function(controller, wall, floor, leftmonitor, rightmonitor) {
  ui <- shinyUI(bootstrapPage(
    HTML('<script type="text/javascript">
         $(function() {
         $("div.Window").hide(); 
         var tokens = window.location.href.split("?");
         if (tokens.length > 1) {
         var shown_window = tokens[1];
         $("div."+shown_window).show();
         } else {
         $("div.WindowSelector").show();
         }
         });
         </script>'),
    div(class="WindowSelector Window",
        HTML('<h2><a href="?Controller">Controller</a></h2>'),
        HTML('<h2><a href="?Wall">Wall</a></h2>'),
        HTML('<h2><a href="?Floor">Floor</a></h2>'),
        HTML('<h2><a href="?LeftMonitor">Left External Monitor</a></h2>'),
        HTML('<h2><a href="?RightMonitor">Right External Monitor</a></h2>'),
        style = 'position: absolute; 
        top: 50%; left: 50%; 
        margin-right: -50%; 
        transform: translate(-50%, -50%)'
    ),
    div(class = "Controller Window",
        controller
    ),
    div(class = "Wall Window",
        wall 
    ),
    div(class = "Floor Window",
        floor
    ),
    div(class = "LeftMonitor Window",
        leftmonitor
    ),
    div(class = "RightMonitor Window",
        rightmonitor
    )
    
    ))
  
  return(ui)
  }
