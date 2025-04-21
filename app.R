library(shiny)
library(DBI)
library(glue)
library(leaflet)
library(RPostgres)

# Connection settings
db <- "shiny"
db_host <- "localhost"
db_port <- "5432"
db_user <- "postgres"
db_pass <- "5050"

# Pre-check: does the table exist?
conn <- dbConnect(
  RPostgres::Postgres(),
  dbname = db,
  host = db_host,
  port = db_port,
  user = db_user,
  password = db_pass
)

# Check available tables
print(dbListTables(conn))

# Try fetching sample data
print(dbGetQuery(conn, "SELECT * FROM earth_data LIMIT 5"))

# Close initial connection
dbDisconnect(conn)

# Load icon
icon_url <- "C:/Users/kariu/OneDrive/Desktop/shiny project/earthquake.png"
quake_icon <- makeIcon(iconUrl = icon_url, iconWidth = 24, iconHeight = 24)

# UI
ui <- fluidPage(
  tags$h1("Earthquake Data Map"),
  sliderInput("magSlider", "Minimum magnitude:", min = 0, max = 10, value = 0, step = 0.1),
  leafletOutput("map")
)

# Server
server <- function(input, output) {
  data <- reactive({
    conn <- dbConnect(
      RPostgres::Postgres(),
      dbname = db,
      host = db_host,
      port = db_port,
      user = db_user,
      password = db_pass
    )
    query <- glue("SELECT * FROM earth_data WHERE richter >= {input$magSlider}")
    quakes <- dbGetQuery(conn, query)
    dbDisconnect(conn)
    quakes
  })
  
  output$map <- renderLeaflet({
    leaflet(data = data()) %>%
      addTiles() %>%
      addMarkers(~longitude, ~latitude, label = ~as.character(richter), icon = quake_icon) %>%
      addProviderTiles(providers$Esri.WorldStreetMap)
  })
}

# Run App
shinyApp(ui = ui, server = server)
