library(RPostgreSQL)
library(dplyr)
library(dbplyr)

#Uvoz:
source("auth.R", encoding="UTF-8")
#source("auth_public.R", encoding="UTF-8")
source("uvoz.r", encoding="UTF-8")
  
# Povezemo se z gonilnikom za PostgreSQL
drv <- dbDriver("PostgreSQL") 

# Funkcija za brisanje tabel
delete_table <- function(){
  # Uporabimo funkcijo tryCatch,
  # da prisilimo prekinitev povezave v primeru napake
  tryCatch({
    # Vzpostavimo povezavo z bazo
    conn <- dbConnect(drv, dbname = db, host = host, user = user, password = password)
    
    # Če tabela obstaja, jo zbrišemo, ter najprej zbrišemo tiste,
    # ki se navezujejo na druge
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS izvajalec CASCADE"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS album CASCADE"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS pesem CASCADE"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS zvrst CASCADE"))
    
  }, finally = {
    dbDisconnect(conn)
  })
}


#Funkcija, ki ustvari tabele
create_table <- function(){
  # Uporabimo tryCatch,(da se povežemo in bazo in odvežemo)
  # da prisilimo prekinitev povezave v primeru napake
  tryCatch({
    # Vzpostavimo povezavo
    conn <- dbConnect(drv, dbname = db, host = host, user = user, password = password)
    
    # Glavne tabele
    izvajalec <- dbSendQuery(conn, build_sql("CREATE TABLE izvajalec (
                                              id INTEGER PRIMARY KEY, 
                                              ime text NOT NULL)"))
    
    album <- dbSendQuery(conn, build_sql("CREATE TABLE album(
                                          id integer PRIMARY KEY,
                                          naslov text NOT NULL)"))
    
    zvrst <- dbSendQuery(conn, build_sql("CREATE TABLE zvrst(
                                          id integer PRIMARY KEY,
                                          ime text NOT NULL)"))
    
    pesem <- dbSendQuery(conn, build_sql("CREATE TABLE pesem(
                                          id integer PRIMARY KEY,
                                          naslov text NOT NULL,
                                          leto integer NOT NULL,
                                          dolzina text NOT NULL )"))
                                         # FOREIGN KEY (zvrst) REFERENCES zvrst(id),
                                        #  FOREIGN KEY (izvajalec) REFERENCES izvajalec(id),
                                        #  FOREIGN KEY (album) REFERENCES album(id))"))
    

    
    dbSendQuery(conn, build_sql("GRANT ALL ON ALL TABLES IN SCHEMA public TO tajad WITH GRANT OPTION"))
    dbSendQuery(conn, build_sql("GRANT ALL ON ALL TABLES IN SCHEMA public TO veronikan WITH GRANT OPTION"))
#    dbSendQuery(conn, build_sql("GRANT ALL ON ALL TABLES IN SCHEMA public TO marinas WITH GRANT OPTION"))

    dbSendQuery(conn, build_sql("GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO tajad WITH GRANT OPTION"))
    dbSendQuery(conn, build_sql("GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO veronikan WITH GRANT OPTION"))
#    dbSendQuery(conn, build_sql("GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO marinas WITH GRANT OPTION"))

    dbSendQuery(conn, build_sql("GRANT CONNECT ON DATABASE sem2018_marinas TO javnost"))
    dbSendQuery(conn, build_sql("GRANT SELECT ON ALL TABLES IN SCHEMA public TO javnost"))
    
  }, finally = {
    # Na koncu nujno prekinemo povezavo z bazo,
    # saj preveč odprtih povezav ne smemo imeti
    dbDisconnect(conn) #PREKINEMO POVEZAVO
    # Koda v finally bloku se izvede, preden program konča z napako
  })
}

#Funcija, ki vstavi podatke
insert_data <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host, user = user, password = password)
    
    dbWriteTable(conn, name="izvajalec", izvajalec, append=T, row.names=FALSE)
    dbWriteTable(conn, name="album", album, append=T, row.names=FALSE)
    dbWriteTable(conn, name="zvrst", zvrst, append=T, row.names=FALSE)
    dbWriteTable(conn, name="pesem", pesem, append=T, row.names=FALSE)

  }, finally = {
    dbDisconnect(conn) 
    
  })
}


pravice <- function(){
  # Uporabimo tryCatch,(da se povežemo in bazo in odvežemo)
  # da prisilimo prekinitev povezave v primeru napake
  tryCatch({
    # Vzpostavimo povezavo
    conn <- dbConnect(drv, dbname = db, host = host,#drv=s čim se povezujemo
                      user = user, password = password)
    
    dbSendQuery(conn, build_sql("GRANT CONNECT ON DATABASE sem2018_marinas TO tajad WITH GRANT OPTION"))
    dbSendQuery(conn, build_sql("GRANT CONNECT ON DATABASE sem2018_marinas TO veronikan WITH GRANT OPTION"))
    
    dbSendQuery(conn, build_sql("GRANT ALL ON SCHEMA public TO tajad WITH GRANT OPTION"))
    dbSendQuery(conn, build_sql("GRANT ALL ON SCHEMA public TO veronikan WITH GRANT OPTION"))
    
    dbSendQuery(conn, build_sql("GRANT ALL ON ALL TABLES IN SCHEMA public TO tajad WITH GRANT OPTION"))
    dbSendQuery(conn, build_sql("GRANT ALL ON ALL TABLES IN SCHEMA public TO veronikan WITH GRANT OPTION"))
#    dbSendQuery(conn, build_sql("GRANT ALL ON ALL TABLES IN SCHEMA public TO marinas WITH GRANT OPTION"))
    
    dbSendQuery(conn, build_sql("GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO tajad WITH GRANT OPTION"))
    dbSendQuery(conn, build_sql("GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO veronikan WITH GRANT OPTION"))
#    dbSendQuery(conn, build_sql("GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO marinas WITH GRANT OPTION"))
    
    dbSendQuery(conn, build_sql("GRANT CONNECT ON DATABASE sem2018_marinas TO javnost"))
    dbSendQuery(conn, build_sql("GRANT SELECT ON ALL TABLES IN SCHEMA public TO javnost"))
    
    
    
  }, finally = {
    # Na koncu nujno prekinemo povezavo z bazo,
    # saj preveč odprtih povezav ne smemo imeti
    dbDisconnect(conn) #PREKINEMO POVEZAVO
    # Koda v finally bloku se izvede, preden program konča z napako
  })
}

pravice()
delete_table()
create_table()
insert_data()

#con <- src_postgres(dbname = db, host = host, user = user, password = password)

