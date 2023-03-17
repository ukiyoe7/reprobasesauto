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

## GET DATA

df2 <- dbGetQuery(con2, statement = read_file("C:\\Users\\Repro\\Documents\\R\\ADM\\BASES_AUTO\\SQL\\PRODUTOS_ADM.sql")) 


View(df2)

mutate(LENTES=str_trim(LENTES))%>% 

## SHARE PILARES
  
  
SHARE_PILARES <-
  df2  %>% mutate(LENTES=str_trim(LENTES)) %>%  filter(LENTES=='LENTES') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month"),PILARES) %>%  
  summarize(
            SHARE = round(sum(VRVENDA) / sum(.$VRVENDA[floor_date(.$PEDDTBAIXA, "year") == 
                                                                floor_date(PEDDTBAIXA, "year") & 
                                                                floor_date(.$PEDDTBAIXA, "month") == 
                                                   floor_date(PEDDTBAIXA, "month")]), 3)) %>% 
  melt(.,id.vars = c("MES", "PILARES"),variable.name = "METRICA",value.name = "VALOR")


SALES_PILARES <-
  df2 %>%  mutate(LENTES=str_trim(LENTES)) %>% filter(LENTES=='LENTES') %>% 
  filter(PEDDTBAIXA %within% 
           interval(cut((Sys.Date()-1)-years(1),"month"),(Sys.Date()-1)-years(1))
         | PEDDTBAIXA  %within% interval(cut((Sys.Date()-1),"month"),Sys.Date()-1)) %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month"),PILARES) %>%  
  summarize(VENDAS=sum(VRVENDA)) %>% as.data.frame() %>% mutate(VAR=VENDAS/lag(VENDAS,7)-1)

TRANSITIONS <-
  df2 %>% 
  filter(PEDDTBAIXA %within% 
           interval(cut(Sys.Date()-years(1),"month"),Sys.Date()-years(1))
         | PEDDTBAIXA  %within% interval(cut(Sys.Date(),"month"),Sys.Date())) %>% 
  filter(TRANSITIONS=='TRANSITIONS') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month"),PILARES=TRANSITIONS) %>%  
  summarize(VENDAS=sum(VRVENDA)) %>% as.data.frame() %>% mutate(VAR=VENDAS/lag(VENDAS,1)-1)


PILARES3 <- 
  rbind(SALES_PILARES,TRANSITIONS) %>% as.data.frame() %>% 
  melt(.,id.vars = c("MES", "PILARES"),variable.name = "METRICA",value.name = "VALOR")


PILARES4 <- rbind(SHARE_PILARES,PILARES3) %>% filter(!is.na(VALOR))

view(PILARES4)




range_write("1AaPXqa1zDw8rDY2o7uyniDIm5VpyJo4j7sZ2bHX8jE0", range = "A:G",data = PILARES4, sheet = "DADOS2",reformat = FALSE)



