library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("united"),
  
  titlePanel("ISKALNIK PESMI"),
  
  sidebarLayout(
    sidebarPanel("živjo"

    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Iskanje po pesmi",
                 
                 sidebarPanel(
                   textInput(inputId="pesem1",label="Naslov pesmi","The Sign")
                 ),
                 
                 mainPanel(
                   # Iskanje po pesmih
                   textOutput("pesem2"),
                   textOutput("album1"),
                   textOutput("leto1"),
                   textOutput("zvrst1"),
                   textOutput("dolzina1")
                 )
                   
                 ),
          
        
        tabPanel("Iskanje po izvajalcu",
                 sidebarPanel(
                   textInput(inputId="izvajalec", label="Izvajalec", "Ace of Bass")
                 ),
                 
                 mainPanel(
                   # Iskanje po izvajalcu
                   tableOutput("seznam_pesmi")
                 
                 )
        ),
    
        tabPanel("Iskanje po albumih",
                 sidebarPanel(
                   textInput(inputId="album",label="Album","Happy Nation")
                 ),
                 
                 mainPanel(
                   # Iskanje po albumu
                   tableOutput("tabelapesmi")
                 ) 
                 
      ),
  
      tabPanel("Iskanje po zvrsti",
               sidebarPanel(
                 textInput(inputId="zvrst", label="Zvrst", "Pop")
               ),
               
               mainPanel(
                 # Iskanje po zvrsti
                 tableOutput("seznam1")
               )
               
      ),
  
      tabPanel("Iskanje po letu",
               sidebarPanel(
                 sliderInput("leta",
                             "Leto skladbe:",
                             min = 1970,
                             max = 2015,
                             value = c(1980,2000))
               ),

               mainPanel(
                 # Iskanje po letu
                 tableOutput("tabelaleta")
                 
              
               )
      )
      
      
  )    )    )    )    )


