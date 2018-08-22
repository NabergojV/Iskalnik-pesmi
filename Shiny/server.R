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
  tbl.letnica<-tbl(conn, "letnica")
  
  tidy_tabela <- tbl.izvaja %>% 
    inner_join(tbl.nahaja) %>% 
    inner_join(tbl.ima) %>%
    inner_join(tbl.nosi) %>%
    inner_join(tbl.izvajalec, by = c("izvajalec_id" = "id")) %>% rename(izvajalec = ime) %>%
    inner_join(tbl.album, by = c("album_id" = "id")) %>% rename(album = naslov) %>%
    inner_join(tbl.zvrst, by = c("zvrst_id" = "id")) %>% rename(zvrst = ime) %>%
    inner_join(tbl.pesem, by = c("pesem_id" = "id"))

  zdruzi <- . %>% group_by(pesem_id, naslov, leto, dolzina) %>%
    summarise(izvajalec = string_agg(distinct(izvajalec), "; "),
              album = string_agg(distinct(album), "; "),
              zvrst = string_agg(distinct(zvrst), "; ")) %>% ungroup() %>% select(-pesem_id)  
  
  
  
  #ZAVIHEK: Iskanje po pesmi
  
  zdruzena.pesmi <- reactive({
    tidy_tabela %>% filter(naslov %ILIKE% "%" %||% input$pesem1 %||% "%") %>% zdruzi()
  })  
  
  output$pesem55<- renderTable({
    zdruzena.pesmi() %>% head(10)
  })
  
  output$pesem2 <- renderText({
    stevilo <- count(zdruzena.pesmi()) %>% pull()
    if (stevilo <= 0) {
      return("Pesmi ni v bazi")
    } else if (stevilo > 10) {
      return("Zadetkov je več kot je prikazanih")
    }
  })
  
  # izvajalec <- reactive({
  #   indeks1=tbl.pesem %>% filter(naslov %ILIKE% "%" %||% input$pesem1 %||% "%")
  #   #indeks1=tbl.pesem %>%  filter(tolower(naslov)==tolower(input$pesem1))
  #   if(count(indeks1)%>%pull()==0){
  #     return("Pesmi ni v bazi")
  #   } else{
  #     indeks= indeks1%>% select(id) %>% pull()
  #     izvajalec_id1 <- tbl.izvaja %>% filter(pesem_id==indeks) %>% select(izvajalec_id) %>% pull()
  #     izv<-tbl.izvajalec %>% filter(id==izvajalec_id1) %>% select(ime) %>% pull()
  #     paste("Izvajalec: ", izv )
  #   }
  # })
  # 
  # dolzina <- reactive({
  #   dolz=tbl.pesem %>% filter(naslov %ILIKE% "%" %||% input$pesem1 %||% "%")
  #   #dolz=tbl.pesem %>%  filter(tolower(naslov)==tolower(input$pesem1))
  #   if(count(dolz)%>%pull()==0){
  #     return("")
  #   } else{
  #     dolz2=dolz %>% select(dolzina) %>% pull()
  #     paste("Dolžina: ", dolz2 )
  #   }
  # })
  # 
  # 
  # leto <- reactive({
  #   indeks1=tbl.pesem %>% filter(naslov %ILIKE% "%" %||% input$pesem1 %||% "%")
  #   #indeks1=tbl.pesem %>%  filter(tolower(naslov)==tolower(input$pesem1))
  #   if(count(indeks1)%>%pull()==0){
  #     return("")
  #   } else{
  #     leto2= indeks1%>% select(leto)  %>% pull()
  #     paste("Leto: ", leto2)
  #   }
  # })
  # 
  # album <- reactive({
  #   indeks1=tbl.pesem %>% filter(naslov %ILIKE% "%" %||% input$pesem1 %||% "%")
  #   #indeks1=tbl.pesem %>%  filter(tolower(naslov)==tolower(input$pesem1))
  #   if(count(indeks1)%>%pull()==0){
  #     return("")
  #   } else{
  #     indeks= indeks1%>% select(id) %>% pull()
  #     album_id1 <- tbl.nahaja %>% filter(pesem_id==indeks) %>% select(album_id) %>% pull()
  #     album1=tbl.album %>% filter(id==album_id1) %>% select(naslov) %>% pull()
  #     paste("Album: ", album1 )
  #   }
  # })
  # 
  # zvrst <- reactive({
  #   indeks1=tbl.pesem %>% filter(naslov %ILIKE% "%" %||% input$pesem1 %||% "%")
  #   #indeks1=tbl.pesem %>%  filter(tolower(naslov)==tolower(input$pesem1))
  #   if(count(indeks1)%>%pull()==0){
  #     return("")
  #   } else{
  #     indeks= indeks1%>% select(id) %>% pull()
  #     zvrst_id1 <- tbl.ima %>% filter(pesem_id==indeks) %>% select(zvrst_id) %>% pull()
  #     zvrst1=tbl.zvrst %>% filter(id==zvrst_id1) %>% select(ime) %>% pull()
  #     paste("Zvrst: ", zvrst1 )
  #   }
  # })
  
  #leto <- reactive({tbl.pesem %>% filter(tolower(naslov)==tolower(input$pesem1)) %>% select(leto) %>% pull()})
  #album <- reactive({
  #  indeks <- tbl.pesem %>% filter(tolower(naslov)==tolower(input$pesem1)) %>% select(id) %>% pull()
  #
  # })
  #zvrst <- reactive({
  #  indeks <- tbl.pesem %>% filter(tolower(naslov)==tolower(input$pesem1)) %>% select(id) %>% pull()
  #   zvrst_id1 <- tbl.ima %>% filter(pesem_id==indeks) %>% select(zvrst_id) %>% pull()
  #  tbl.zvrst %>% filter(id==zvrst_id1) %>% select(ime) %>% pull()
  #})

  # output$pesem2 <- renderText(izvajalec())
  # output$album1 <- renderText(album())
  # output$leto1 <- renderText(leto())
  # output$zvrst1 <- renderText(zvrst())
  # output$dolzina1 <- renderText(dolzina())

  
  #ZAVIHEK: Iskanje po izvajalcu
  
  zdruzena.izvajalci <- reactive({
    tidy_tabela %>% filter(izvajalec %ILIKE% "%" %||% input$izvajalec %||% "%") %>% zdruzi()
  })  
  
  output$izvajalec55<- renderTable({
    zdruzena.izvajalci() %>% head(10)
  })
  
  output$izvajalec2 <- renderText({
    stevilo <- count(zdruzena.izvajalci()) %>% pull()
    if (stevilo <= 0) {
      return("Izvajalca ni v bazi")
    } else if (stevilo > 10) {
      return("Zadetkov je več kot je prikazanih")
    }
  })
  
  
  # sez_pesmi <- reactive({
  #   indeks <- tbl.izvajalec %>% filter(tolower(ime)==tolower(input$izvajalec)) 
  #   if(count(indeks)%>% pull()==0){
  #     return("Izvajalca ni v bazi")
  #   } else{
  #     ind=indeks %>% select(id)%>% pull()
  #     pesmiid <- tbl.izvaja %>% filter(izvajalec_id==ind) %>% select(pesem_id) %>% pull()
  #     pesmi <- tbl.pesem %>% filter(id %in% pesmiid)
  #     paste("",pesmi)
  #   }
  # 
  # })
  
  # output$seznam_pesmi<- renderTable({
  #   indeks=tbl.izvajalec %>% filter(ime %ILIKE% "%" %||% input$izvajalec %||% "%")
  #   
  #   #indeks <- tbl.izvajalec %>% filter(tolower(ime)==tolower(input$izvajalec)) 
  #   if(count(indeks)%>% pull()==0){
  #     return("Izvajalca ni v bazi")
  #   } else{
  #     ind=indeks %>% select(id)%>% pull()
  #     pesmiid <- tbl.izvaja %>% filter(izvajalec_id==ind) %>% select(pesem_id) %>% pull()
  #     pesmi <- tbl.pesem %>% filter(id %in% pesmiid) %>% select(c(naslov,leto,dolzina))
  #     #paste("",pesmi)
  #     pesmi
  #   }
    
    #sez_pesmi()%>% select(c(naslov,leto,dolzina))
    
    # })
  
  #ZAVIHEK: Iskanje po albumu
  
  zdruzena.albumi <- reactive({
    tidy_tabela %>% filter(album %ILIKE% "%" %||% input$album %||% "%") %>% zdruzi()
  })  
  
  output$album55<- renderTable({
    zdruzena.albumi() %>% head(50)
  })
  
  output$album2 <- renderText({
    stevilo <- count(zdruzena.albumi()) %>% pull()
    if (stevilo <= 0) {
      return("Albuma ni v bazi")
    } else if (stevilo > 50) {
      return("Zadetkov je več kot je prikazanih")
    }
  }) 
  

  # output$tabelapesmi <- renderTable({
  #  indeks2=tbl.album %>% filter(naslov %ILIKE% "%" %||% input$album %||% "%")
  #  #indeks2 <- tbl.album %>% filter(tolower(naslov)==tolower(input$album)) 
  #  if(count(indeks2)%>% pull()==0){
  #    return("Albuma ni v bazi")
  #  } else if(count(indeks2) %>% pull()>=22){
  #    return("Preveč zadetkov")
  #  } else{
  #      indeks22=indeks2 %>% select(id) %>% pull()
  #      pesmiceid <- tbl.nahaja %>% filter(album_id==indeks22) %>% select(pesem_id) %>% pull()
  #      pesmice <- tbl.pesem %>% filter(id %in% pesmiceid) %>% select(c(naslov,leto,dolzina))
  #      pesmice
  #    }
  # })


  #ZAVIHEK: Iskanje po zvrsti
  
  zdruzena.zvrsti <- reactive({
    tidy_tabela %>% filter(zvrst %ILIKE% "%" %||% input$zvrst %||% "%") %>% zdruzi()
  })  
  
  output$seznam1<- renderTable({
    zdruzena.zvrsti()
  })
  
  # output$seznam1 <- renderTable({
  #  indeks_zvrsti <- tbl.zvrst %>% filter(ime==input$zvrst) %>% select(id) %>% pull()
  #  pesmiceid <- tbl.ima %>% filter(zvrst_id==indeks_zvrsti) %>% select(pesem_id) %>% pull()
  #  pesmice <- tbl.pesem %>% filter(id %in% pesmiceid) %>% select(c(naslov,leto,dolzina))
  #  pesmice
  # })  
  # output$pesem2 <- renderText({
  #   stevilo <- count(zdruzena.pesmi()) %>% pull()
  #   if (stevilo <= 0) {
  #     return("Pesmi ni v bazi")
  #   } else if (stevilo > 10) {
  #     return("Zadetkov je več kot je prikazanih")
  #   }
  # })

  #ZAVIHEK: Iskanje po letih
  
  #zdruzena.leta <-({
  #   tidy_tabela  %>% filter(leto >= input$leta[1]) %>% filter(leto <= input$leta[2])%>% arrange(leto) %>% data.frame() %>% select(c(naslov, leto,dolzina)) %>% zdruzi()
  # })
  # 
  # output$tabelaleta <- renderTable({
  #   zdruzena.leta()
  # })
  

  output$tabelaleta <- renderTable({
    l <- tbl.letnica %>% filter(leto >= input$leta[1]) %>% filter(leto <= input$leta[2]) %>% arrange(leto) %>% data.frame() %>% select(c(naslov, izvajalec, leto,dolzina))
    l
  })
  
  
  
  
})


