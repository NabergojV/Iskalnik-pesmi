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
                   fileEncoding = "WINDOWS-1252",
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


# posamezne tabele

izvajalec <- list(tidy_tabela[1])
#izbrise iste vrstice
izbrisi <- function(seznam){
  nov_seznam <- c()
  for (i in seznam){
    if (i not in nov_seznam){
      append(nov_seznam,i)
    }
    else{
    }
  }
}


