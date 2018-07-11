library(shiny)
library(dplyr)
library(RPostgreSQL)

source("../auth_public.R")

shinyServer(function(input, output) {
  # Vzpostavimo povezavo
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  
  # Povežemo se s tabelami, ki jih bomo rabili
  tbl.pesem <- tbl(conn, "pesem")
  tbl.izvajalec <- tbl(conn, "izvajalec")
  tbl.album <- tbl(conn, "album")
  tbl.zvrst <- tbl(conn, "zvrst")
  tbl.nahaja <- tbl(conn, "nahaja")
  tbl.ima <- tbl(conn, "ima")
  tbl.izvaja <- tbl(conn, "izvaja")
  tbl.nosi <- tbl(conn, "nosi")
  
  
  # Iskanje po pesmi
  
  dolzina <- reactive({tbl.pesem %>% filter(naslov==input$pesem1) %>% select(dolzina) %>% pull()})
  
  leto <- reactive({tbl.pesem %>% filter(naslov==input$pesem1) %>% select(leto) %>% pull()})
  album <- reactive({
    indeks <- tbl.pesem %>% filter(naslov==input$pesem1) %>% select(id) %>% pull()
    album_id1 <- tbl.nahaja %>% filter(pesem_id==indeks) %>% select(album_id) %>% pull()
    tbl.album %>% filter(id==album_id1) %>% select(naslov) %>% pull()
  })
  zvrst <- reactive({
    indeks <- tbl.pesem %>% filter(naslov==input$pesem1) %>% select(id) %>% pull()
    zvrst_id1 <- tbl.ima %>% filter(pesem_id==indeks) %>% select(zvrst_id) %>% pull()
    tbl.zvrst %>% filter(id==zvrst_id1) %>% select(ime) %>% pull()
  })
  izvajalec <- reactive({
    indeks <- tbl.pesem %>% filter(naslov==input$pesem1) %>% select(id) %>% pull()
    izvajalec_id1 <- tbl.izvaja %>% filter(pesem_id==indeks) %>% select(izvajalec_id) %>% pull()
    tbl.izvajalec %>% filter(id==izvajalec_id1) %>% select(ime) %>% pull()
  })
  
  output$pesem2 <- renderText({paste("Izvajalec: ", izvajalec() )})
  output$album1 <- renderText({paste("Album: ", album() )})
  output$leto1 <- renderText({c(paste("Leto: ", leto()  ))})
  output$zvrst1 <- renderText({c(paste("Zvrst: ", zvrst()  ))})
  output$dolzina1 <- renderText({c(paste("Dolzina: ", dolzina()  ))})

  
  # Iskanje po izvajalcu
  
  # output$seznam_pesmi <- renderTable({
  #   indeks <- tbl.izvajalec %>% filter(ime==input$izvajalec) %>% select(id) %>% pull()
  #   pesmiid <- tbl(conn, "izvaja") %>% filter(izvajalec_id==indeks) %>% select(pesem_id) %>% pull()
  #   pesmi <- tbl.pesem %>% filter(id %in% pesmiid)
  #   pesmi
  # })
  
  
  # Iskanje po albumu
  
  output$tabelapesmi <- renderTable({
   indeks2 <- tbl.album %>% filter(naslov==input$album) %>% select(id) %>% pull()
   pesmiceid <- tbl.nahaja %>% filter(album_id==indeks2) %>% select(pesem_id) %>% pull()
   pesmice <- tbl.pesem %>% filter(id %in% pesmiceid)
   pesmice    
  })


  # Iskanje po zvrsti
  
  output$seznam1 <- renderTable({
   indeks_zvrsti <- tbl.zvrst %>% filter(ime==input$zvrst) %>% select(id) %>% pull()
   pesmiceid <- tbl.ima %>% filter(zvrst_id==indeks_zvrsti) %>% select(pesem_id) %>% pull()
   pesmice <- tbl.pesem %>% filter(id %in% pesmiceid)
   pesmice
  })



  # Iskanje po letih

  # output$tabelaleta <- renderTable({
  #  l <- tbl.pesem %>% filter(leto > input$min) %>% filter(leto < input$max) %>% arrange(leto) %>% data.frame()
  #  l
  # })

})


