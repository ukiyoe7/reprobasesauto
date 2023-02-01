## ADM DASHBOARD

library(DBI)
library(tidyverse)
library(googlesheets4)
library(lubridate)
library(reshape2)



con2 <- dbConnect(odbc::odbc(), "reproreplica")

## SALES PERFORMANCE

df <- dbGetQuery(con2, statement = read_file("C:\\Users\\Repro\\Documents\\R\\ADM\\BASES_AUTO\\SQL\\RESULT_ADM.sql"))


range_write("17W3qQfIhG6yBAZFCCxVeumscNjGl-aM3FVz2tAr36wo", range = "A:D",data = df, sheet = "DADOS1",reformat = FALSE)

## PRODUCTS VIEW


df2 <- dbGetQuery(con2, statement = read_file("C:\\Users\\Repro\\Documents\\R\\ADM\\BASES_AUTO\\SQL\\PRODUTOS_ADM.sql")) %>% 
        mutate(CLASSE1=trimws(CLASSE1)) %>% 
          mutate(CLASSE2=trimws(CLASSE2))


View(df2)

cat1 <-
 df2 %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month"),CLASSE1) %>%  
  summarize(VENDAS=sum(VRVENDA),SHARE = round(VENDAS / sum(.$VRVENDA[floor_date(df2$PEDDTBAIXA, "year") == floor_date(PEDDTBAIXA, "year") & floor_date(df2$PEDDTBAIXA, "month") == floor_date(PEDDTBAIXA, "month")]), 3))%>% 
  select(CLASSE1, VENDAS, SHARE) %>% 
  as.data.frame(.) %>% 
  melt(.,id.vars = c("MES", "CLASSE1")) %>% 
  rename(MARCA=2,INDICATOR=3,VALUE=4) %>% 
  mutate(CATEGORY=1)


cat2 <-
df2 %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month"),CLASSE2) %>%  
  summarize(VENDAS=sum(VRVENDA),SHARE = round(VENDAS / sum(.$VRVENDA[floor_date(df2$PEDDTBAIXA, "year") == floor_date(PEDDTBAIXA, "year") & floor_date(df2$PEDDTBAIXA, "month") == floor_date(PEDDTBAIXA, "month")]), 3))%>% 
  select(CLASSE2, VENDAS, SHARE) %>% 
  as.data.frame(.) %>% View()
  melt(.,id.vars = c("MES", "CLASSE2")) %>% 
  rename(MARCA=2,INDICATOR=3,VALUE=4) %>% 
  mutate(CATEGORY=2) 

cat3<-
df2 %>% 
     group_by(MES=floor_date(PEDDTBAIXA,"month"),CLASSE3) %>%  
      summarize(VENDAS=sum(VRVENDA),SHARE = round(VENDAS / sum(.$VRVENDA[floor_date(df2$PEDDTBAIXA, "year") == floor_date(PEDDTBAIXA, "year") & floor_date(df2$PEDDTBAIXA, "month") == floor_date(PEDDTBAIXA, "month")]), 3))%>% 
       select(CLASSE3, VENDAS, SHARE) %>% 
        as.data.frame(.) %>% 
         melt(.,id.vars = c("MES", "CLASSE3")) %>% 
          rename(MARCA=2,INDICATOR=3,VALUE=4) %>% 
           mutate(CATEGORY=3)


cat123 <- rbind(cat1,cat2,cat3) 


range_write("17W3qQfIhG6yBAZFCCxVeumscNjGl-aM3FVz2tAr36wo", range = "A:G",data = cat123, sheet = "DADOS2",reformat = FALSE)