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
                   encoding = "UTF-8",
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

#write.csv(tidy_tabela, "tabela.csv")


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


# tabela pesmem
pesem_id <- c(1:length(tidy_tabela$`song name`))
pesmi <- tidy_tabela[ , c(2,4,6)]
pesem <- data.frame(id=pesem_id, pesmi)
imena_stolpcev <- c("id", "naslov", "leto", "dolzina")
colnames(pesem) <- imena_stolpcev


# tabela izvaja
izvaja1 <- tidy_tabela[, c(1,2,4,6)]
colnames(izvaja1) <- c("izvajalec", "naslov", "leto", "dolzina")
izvaja1 <- merge(x = izvaja1, y = pesem, by = c("naslov", "leto", "dolzina"))
colnames(izvaja1)[colnames(izvaja1) == 'id'] <- 'pesem_id'
izvaja1 <- izvaja1[with(izvaja1, order(pesem_id)),]
izvaja2 <- merge(x = izvaja1, y = izvajalec, by.x = "izvajalec", by.y = "ime")
colnames(izvaja2)[colnames(izvaja2) == 'id'] <- 'izvajalec_id'
izvaja2 <- izvaja2[5:6]
izvaja <- izvaja2[with(izvaja2, order(pesem_id)),]


# tabela ima
ima1 <- tidy_tabela[,c(2,5,6)]
colnames(ima1) <- c("naslov", "zvrst", "dolzina")
ima1 <- merge(ima1, pesem, by = c("naslov", "dolzina") )
ima2 <- merge(ima1, zvrst, by.x = "zvrst", by.y = "ime")
ima <- ima2[, c(4,6)]
colnames(ima) <- c("pesem_id", "zvrst_id")
ima <- ima[with(ima, order(pesem_id)),]


# tabela nahaja
nahaja1 <- tidy_tabela[,c(2,3,6)]
colnames(nahaja1) <- c("naslov", "album", "dolzina")
nahaja1 <- merge(nahaja1, pesem, by = c("naslov", "dolzina"))
nahaja2 <- merge(nahaja1, album, by.x = "album", by.y = "naslov")
nahaja <- data.frame(pesem_id = nahaja2$id.x, album_id = nahaja2$id.y)
colnames(nahaja) <- c("pesem_id", "album_id")
nahaja <- nahaja[with(nahaja, order(pesem_id)),]

# album1 <- tidy_tabela[,c(3,4)]
# album1 <- unique(album1)
# album1_id <- c(1:length(album1$year))
# album1 <- data.frame(album1_id, album1)
# colnames(album1) <- c("album_id", "album", "leto")


# tabela nosi
nosi1 <- unique(tidy_tabela[,c(1,3,4)])
colnames(nosi1) <- c("izvajalec", "album", "leto")
nosi1 <- merge(nosi1, album, by.x = "album", by.y = "naslov")
nosi2 <- merge(nosi1, izvajalec, by.x = "izvajalec", by.y = "ime")
nosi <- data.frame(izvajalec_id = nosi2$id.y, album_id = nosi2$id.x)
nosi <- nosi[with(nosi, order(izvajalec_id)),]

