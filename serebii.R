library(XML)
library(RCurl)
library(dplyr)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem",package = "RCurl")))

path <- "https://www.serebii.net/pokedex-sm/egg/bug.shtml"
webpage <- getURL(path)
webpage <- readLines(tc <- textConnection(webpage)); close(tc)
pagetree <- htmlTreeParse(webpage, error=function(...){}, useInternalNodes = T, encoding='UTF-8') 

egg<- xpathSApply(pagetree, "//option",xmlValue,simplify = T)
egg<- egg[2:15]%>%
    gsub(' Egg Group\n', '', ., perl = TRUE)%>%
    gsub(' ','',.)%>%
    tolower(.)%>%
    c(.,"noeggs")

egg<-egg[1:15]
path <- sapply(egg,function(x){paste0("https://www.serebii.net/pokedex-sm/egg/",x,".shtml")})

egg<-sapply(egg,(function(name){paste0(toupper(substr(name, 1, 1)), substr(name, 2, nchar(name)),'.egg')}))

for (cont in 1:length(path)){
    webpage <- getURL(path[cont])
    webpage <- readLines(tc <- textConnection(webpage)); close(tc)
    pagetree <- htmlTreeParse(webpage, error=function(...){}, useInternalNodes = T, encoding='UTF-8') 
    cols <- c("Number","Pokemon","HP","Attack","Defense","Special.Attack","Special.Defense","Speed")
    poke <- xpathSApply(pagetree,"//table[@class='dextable']/tr/td[@class = 'fooinfo']",xmlValue)%>%
        gsub('\n', '', ., perl = TRUE)%>%
        gsub('\t', '', ., perl = TRUE)%>%
        gsub('^ ', '', ., perl = TRUE)%>%
        (function(x){x<-x[x!= ""];dim(x) <- c(10,length(x)/10);t(x)})%>%
        as_tibble()%>%
        select(c(1,2,4,5,6,7,8,9))%>%
        (function(x){colnames(x)<-cols; x})%>%
        mutate(HP = as.integer(HP),
               Attack = as.integer(Attack),
               Defense = as.integer(Defense),
               Special.Attack = as.integer(Special.Attack),
               Special.Defense = as.integer(Special.Defense),
               Speed = as.integer(Speed),
               Total = HP+Attack+Defense+Special.Attack+Special.Defense+Speed,
               Group = TRUE)
    colnames(poke) <- c(cols,'Total',egg[cont])
    
    type<-xpathSApply(pagetree,"//table[@class='dextable']/tr/td[@class = 'fooinfo']/a", xmlGetAttr, 'href')
    type<-type[!grepl("abilitydex",type)]
    type<-type[grepl("^/",type)]
    type<-gsub("/pokedex-sm/","",type)
    type<-gsub(".shtml","",type)
    cond <- sum(grepl("[0-9]",type))!=1
    if (cond){
        type<-split(type,cumsum(grepl('[0-9]',type)))
        type<-lapply(type,(function(name){paste0(toupper(substr(name, 1, 1)), substr(name, 2, nchar(name)))}))
        type[lapply(type,length)==2]=lapply(c(type[lapply(type,length)==2]),c,NA)
    } else {
        type<-sapply(type,(function(name){paste0(toupper(substr(name, 1, 1)), substr(name, 2, nchar(name)))}))
        type <- c(type,NA)
    }
    type<- as_tibble(t(as_tibble(type)))
    colnames(type)<- c('Number','Type.1','Type.2')
    
    gen <- with(type,(1+as.integer(Number>151) + as.integer(Number>251) + as.integer(Number>386) + as.integer(Number>493) + as.integer(Number>649) + as.integer(Number>721) + as.integer(Number>807)))
    
    type <- type %>%
        mutate(Generation = as.integer(gen))%>%
        mutate(Number = paste0("#",Number))
    poke <- left_join(poke,type,by='Number')
    
    if (cont == 1) {pokemon <- poke}
    else{pokemon <- full_join(pokemon,poke,by = c(cols,'Total','Type.1','Type.2','Generation'))}
}
pokemon<- pokemon%>%
    arrange(Number)%>%
    mutate_at(vars(egg),funs(!is.na(.))) %>%
    select(c(1,2,13,11,12,9,3:8,10,14:27))

write.csv(pokemon,file = "pokemon.csv", row.names = F)