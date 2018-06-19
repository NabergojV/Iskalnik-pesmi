#odpremo pakete:
library(dplyr)
library(gsubfn)
library(ggplot2)
library(XML)
library(eeptools)
library(labeling)
library(rvest)
library(extrafont)

stolpci<-c("artist","song name","album name","year","genre","song length")

#uvozimo podatke:

uvozi<-function(){
  return(read.csv2(file="Music-Database.csv",
                   skip=11,
                   header=FALSE,
                   fileEncoding = "UTF-8",
                   na=c("","??")))
}

tabela<-uvozi()
tabela<-tabela[1:6]
names(tabela)<-stolpci

#izbrišemo nepopolne vrstice (vrstice z NA)

delete.na <- function(DF, n=0) {
  DF[rowSums(is.na(DF)) <= n,]
}

# OK.vrstice <- apply(survey, 1, function(x) {!any(is.na(x)) })

tidy_tabela <- delete.na(tabela)

write.csv(tidy_tabela, "tabela.csv")


# POSAMEZNE TABELE

# tabela izvajalec

authors <- c()
for(author in tidy_tabela$artist){
  if(!(author %in% authors)){
    authors=c(authors, author)
  }
}
author_id <- c(1:length(authors))
izvajalec=data.frame(id=author_id, ime=authors)

# tabela album

naslov_albuma <-c()
for(album in tidy_tabela$`album name`){
  if(!(album %in% naslov_albuma)){
    naslov_albuma=c(naslov_albuma, album)
  }
}
album_id <- c(1:length(naslov_albuma))
album=data.frame(id=album_id, naslov=naslov_albuma)

# tabela zvrst

ime_zvrsti <- c()
for(zvrst in tidy_tabela$genre){
  if(!(zvrst %in% ime_zvrsti)){
    ime_zvrsti=c(ime_zvrsti, zvrst)
  }
}
zvrst_id <- c(1:length(ime_zvrsti))
zvrst=data.frame(id=zvrst_id, ime=ime_zvrsti)

# tabela pesmi

pesem_id <- c(1:length(tidy_tabela$`song name`))
pesmi <- tidy_tabela[ , c(2,4,6)]
pesem <- data.frame(id=pesem_id, pesmi)
imena_stolpcev <- c("id", "naslov", "leto", "dolzina")
colnames(pesem) <- imena_stolpcev

# tabela izvaja
izvaja <- tidy_tabela[, 1:2]
colnames(izvaja) <- c("izvajalec", "pesem")
# tabela ima
ima <- tidy_tabela[,c(2,5)]
colnames(ima) <- c("pesem", "zvrst")
# tabela nahaja
nahaja <- tidy_tabela[,c(2,3)]
colnames(nahaja) <- c("pesem", "album")
# tabela nosi
nosi <- unique(tidy_tabela[,c(1,3)])
colnames(nosi) <- c("izvajalec", "album")

