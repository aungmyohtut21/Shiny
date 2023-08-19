# Load packages 

library(shiny)
library(shinythemes)
library(ggplot2)
library(tidyverse)

#options("shiny.sanitize.errors" = FALSE) # Turn off error sanitization

# Get the data

file <- "https://github.com/rstudio-education/shiny-course/raw/main/movies.RData"
destfile <- "movies.RData"

download.file(file, destfile)

# Load data 

load("movies.RData")

# Define UI 

ui <- fluidPage(theme = shinytheme("cerulean"),
  
  sidebarLayout(
    
    # Inputs: Select variables to plot
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(
        inputId = "y",
        label = "Y-axis:",
        choices = c(
          "IMDB rating" = "imdb_rating",
          "IMDB number of votes" = "imdb_num_votes",
          "Critics score" = "critics_score",
          "Audience score" = "audience_score",
          "Runtime" = "runtime"),
        selected = "audience_score"),
      
      # Select variable for x-axis
      selectInput(
        inputId = "x",
        label = "X-axis:",
        choices = c(
          "IMDB rating" = "imdb_rating",
          "IMDB number of votes" = "imdb_num_votes",
          "Critics score" = "critics_score",
          "Audience score" = "audience_score",
          "Runtime" = "runtime"),
        selected = "critics_score"),
      
    #Show data table
    checkboxInput(inputId = "show_data",label = "Show data table",value = TRUE)),
    
    # Output: Scatter plot and Movies Table
    mainPanel(plotOutput(outputId = "scatterplot"),
      dataTableOutput(outputId = "moviestable"))
    ))


# Define server 

server <- function(input, output, session) {
  #Print Scatterplot
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point()
  })
  
  #Print Data Table if checked
  output$moviestable <- DT::renderDataTable({
    if(input$show_data){
      datatable(data = movies %>% select(1:7),
                    options = list(pageLength = 10),
                    rownames = FALSE)
    }
  })
}

# Create a Shiny app object 

shinyApp(ui = ui, server = server)