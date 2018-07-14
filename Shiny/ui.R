library(shiny)
library(shinythemes)

vse_zvrsti <- c("Pop","Country","Holiday","Variété française","Latino","Children's Music","Schlager, Musik, Pop, Britpop",
                "Schlager, Musik, Weltmusik, Pop, Britpop","Pop, Musik, Weltmusik, Britpop",
                "Schlager, Musik, Musik zum Fest, Weihnachten, Pop, Britpop","Schlager, Musik, Weltmusik, Pop, Britpop, Rock",
                "Schlager, Musik, Rock, Weltmusik, Pop, Britpop","Schlager, Musik, Rock, Pop, Britpop",
                "Bubblegum pop","Axé","Electropop","Pop Latino","Electronic","Dance","Folk","Pop latino",
                "Hip-Hop/Rap","New Age","Vocal","Latin","Alternativo & Rock Latino","Sertanejo","World","Jpop",
                "Volksmusik, Musik","Rock","Children","Eurodance","Pop-rock","Reggae","Bubblegum dance","German Pop, Music, Rock")

shinyUI(fluidPage(theme = shinytheme("darkly"),
  
  titlePanel("ISKALNIK PESMI"),
  
  sidebarLayout(
   sidebarPanel(div("Pozdravljeni v iskalniku pesmi. Tukaj lahko poiščete podatke za pesmi, ki vas zanimajo, 
                lahko pa jih tudi filtrirate glede na izvajalca, album, zvrst ali leto."), style="color:aquamarine"
              
   ),
    
    mainPanel(
      tabsetPanel(
        
        # Iskanje po pesmi
        tabPanel("Iskanje po pesmi",
                 
                 sidebarPanel(
                   textInput(inputId="pesem1",label="Naslov pesmi","The Sign")
                 ),
                 
                tryCatch({
                  mainPanel(
                   textOutput("pesem2"),
                   textOutput("album1"),
                   textOutput("leto1"),
                   textOutput("zvrst1"),
                   textOutput("dolzina1"))
                }, warning = function(w) {
                  return(mainPanel(textOutput("Pesmi ni v bazi")))
                }, error = function(err) {
                  mainPanel(textOutput("Pesmi ni v bazi"))
                }) 
                   
                 ),
          
        # Iskanje po izvajalcu        
        tabPanel("Iskanje po izvajalcu",
                 sidebarPanel(
                   textInput(inputId="izvajalec", label="Izvajalec", "Ace of Base")
                 ),
                 
                 mainPanel(

                   tableOutput("seznam_pesmi")
                 
                 )
        ),
        
        # Iskanje po albumu    
        tabPanel("Iskanje po albumu",
                 sidebarPanel(
                   textInput(inputId="album",label="Album","Happy Nation")
                 ),
                 
                 mainPanel(

                   tableOutput("tabelapesmi")
                 ) 
                 
      ),
      
      # Iskanje po zvrsti  
      tabPanel("Iskanje po zvrsti",
               sidebarPanel(
                 selectInput(inputId="zvrst", label="Zvrst", vse_zvrsti, selected = NULL, multiple = FALSE,
                             selectize = TRUE, width = NULL, size = NULL)
                 
                 #textInput(inputId="zvrst", label="Zvrst", "Pop")
               ),
               
               mainPanel(

                 tableOutput("seznam1")
               )
               
      ),
                 
      # Iskanje po letu  
      tabPanel("Iskanje po letu",
               sidebarPanel(
                 sliderInput("leta",
                             "Leto skladbe:",
                             min = 1970,
                             max = 2015,
                             value = c(1980,2000))
               ),

               mainPanel(

                 tableOutput("tabelaleta")
                 
              
               )
      )
      
      
  )    )    )    )    )


