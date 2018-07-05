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
  indeks<-reactive({tbl(conn,"pesem")%>%filter(naslov==input$pesem1)%>%select(id)})
  izvajalec_id1<-tbl(conn,"izvaja")%>%filter(pesem_id==indeks)%>%select(izvajalec_id)
  izvajalec<-tbl(conn,"izvajalec")%>%filter(id==izvajalec_id1)%>%select(ime)%>%as.character()
  output$pesem2<-renderText({c(paste("Izvajalec:",izvajalec[1]))})
  output$test<-renderText({input$pesem1})
  
})
