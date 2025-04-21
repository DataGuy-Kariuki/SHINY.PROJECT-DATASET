## install packages if not already installed

#install.packages("DBI")
#install.packages("shiny")
#install.packages("glue")
#install.packages("leaflet")
#install.packages("RPostgres")
#install.packages("RPostgreSQL")


## load libraries

library(shiny)
library(DBI)
library(glue)
library(leaflet)
library(RPostgres)
library(RPostgreSQL)

## load database connection

db <- "shiny"
db_host <- "localhost"
db_port <- "5432"
db_user <- "postgres"
db_pass <- "5050"

conn <- dbConnect(
  RPostgres::Postgres(),
  dbname = db,
  host = db_host,
  port = db_port,
  user = db_user,
  password = db_pass
)

# Checking the connection

dbListTables(conn)

## we want to fetch data from it now and we are using dbgetQuery to do so

dbGetQuery(conn, "SELECT * FROM earth_data LIMIT 5")
