library(shiny)
library(maps)
library(mapproj)
library(shinythemes)

#runUrl("http://pages.stat.wisc.edu/~karlrohe/ds479/code/census-app.zip")

setwd("/Users/erika/Desktop/UW/2021fall/hw")
countries <- readRDS("CensusApp/data/counties.rds")
source("CensusApp/helpers.R")

percent_map(countries$white, "darkgreen", "% White")

# User interface 
ui <- fluidPage(theme = shinytheme("cerulian"),
  titlePanel("CensusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(plotOutput("map"))
  )
)
  
# Server function 
server <- function(input, output){
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    legend <- switch(input$var, 
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    percent_map(var = data, color, legend, input$range[1], input$range[2])
  
      })
}

#Shiny App function - Run app 
shinyApp(ui = ui, server = server)
#runApp("CensusApp", display.mode = "showcase")
