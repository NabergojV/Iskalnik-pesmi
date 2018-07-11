library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("darkly"),
  
  titlePanel("ISKALNIK PESMI"),
  
  sidebarLayout(
    sidebarPanel(
      textInput(inputId="pesem1",label="Naslov pesmi","The Sign"),
      textInput(inputId="izvajalec", label="Izvajalec", "Ace of Bass"),
      textInput(inputId="album",label="Album","Happy Nation"),
      textInput(inputId="zvrst", label="Zvrst", "Pop"),
      sliderInput("leta",
                  "Leto skladbe:",
                  min = 1970,
                  max = 2015,
                  value = 1990)
    ),
    
    mainPanel(
      
      # Iskanje po pesmih
      textOutput("pesem2"),
      textOutput("album1"),
      textOutput("leto1"),
      textOutput("zvrst1"),
      textOutput("dolzina1"),
      
      # Iskanje po izvajalcu
      tableOutput("seznam_pesmi"),
      
      # Iskanje po albumih
      tableOutput("tabelapesmi"),
      
      # Iskanje po zvrsti
      tableOutput("seznam1"),
      
      # Iskanje po letih
      tableOutput("tabelaleta")
    )
  )
)
)

