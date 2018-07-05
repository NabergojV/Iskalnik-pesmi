#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
source("../auth_public.R")

shinyServer(function(input, output) {
  conn<-src_postgres(dbname=db,host=host,user=user,password=password)
  #kle demalo pesmice
  indeks<-reactive({tbl(conn,"pesem")%>%filter(naslov==input$pesem1)%>%select(id)})
  dolzina<-reactive({tbl(conn,"pesem")%>%filter(naslov==input$pesem1)%>%select(dolzina)})
  leto<-reactive({tbl(conn,"pesem")%>%filter(naslov==input$pesem1)%>%select(leto)})
  izvajalec_id1<-tbl(conn,"izvaja")%>%filter(pesem_id==indeks)%>%select(izvajalec_id)
  izvajalec<-tbl(conn,"izvajalec")%>%filter(id==izvajalec_id1)%>%select(ime)%>%as.character()
  output$pesem2<-renderText({c(paste("Izvajalec:",izvajalec))})
  output$leto1<-renderText({c(paste("Leto: ",leto))})
  output$dolzina2<-renderText({c(paste("Dolzina: ",dolzina))})
  output$test<-renderText({input$pesem1})
  #kle delamo album
  output$tabelapesmi<-renderDataTable({
    indeks2<-reactive({tbl(conn,"album")%>%filter(naslov==input$album1)%>%select(id)})
    pesmiceid<-tbl(conn,"nahaja")%>%filter(album_id==indeks2)%>%select(pesem_id)
    pesmice<-tbl(conn,"pesem")%>%subset(id %in% pesmiceid)
    pesmice
    

  })
  leta<-tbl(conn,"pesem")
  leta<-reactive({filter(leta,leto<=input$leta)})
  leta<-reactive({filter(leta,leto>=input$leta[2])})
  output$tabelaleta(leta)
  
})



