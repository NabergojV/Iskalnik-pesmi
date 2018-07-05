#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# library(shiny)
# 
# # Define UI for application that draws a histogram
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("Old Faithful Geyser Data"),
#   
#   # Sidebar with a slider input for number of bins 
#   sidebarLayout(
#     sidebarPanel(
#        sliderInput("bins",
#                    "Number of bins:",
#                    min = 1,
#                    max = 50,
#                    value = 30)
#     ),
#     
#     # Show a plot of the generated distribution
#     mainPanel(
#        plotOutput("distPlot")
#     )
#   )
# ))
library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  
  titlePanel("ISKALNIK PESMI"),
  
  sidebarLayout(
    sidebarPanel(
      textInput(inputId="pesem1",label="Naslov pesmi","The Sign"),
      selectInput(inputId = "type", label = strong("Naslov pesmi"),
                  choices = c("bla", "tra"),
                  selected = "bla")),
      sliderInput("min",
                  "Minimalni znesek transakcije:",
                  min = -10000,
                  max = 10000,
                  value = 1000)
    ),
    
    mainPanel(
      textOutput("pesem2"),
      textOutput("test")
    )
  )
)


