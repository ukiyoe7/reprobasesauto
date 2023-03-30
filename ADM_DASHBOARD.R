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

df2 <- dbGetQuery(con2, statement = read_file("C:\\Users\\Repro\\Documents\\R\\ADM\\BASES_AUTO\\SQL\\PRODUTOS_ADM.sql")) %>% 
              mutate(PILARES=str_trim(PILARES)) %>% 
               mutate(LENTES=str_trim(LENTES)) %>% 
                mutate(TIPO=str_trim(TIPO)) %>% 
                 mutate(MPROPRIA=str_trim(MPROPRIA))


View(df2)

## SHARE VARILUX ==============================================================

SHARE_VARILUX_MM <-
  df2   %>%  filter(PILARES=='VARILUX') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>% mutate(PILAR="VARILUX")


SHARE_MULTIFOCAIS_MM <-
  df2   %>%  filter(TIPO=='MULTIFOCAIS') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>%  mutate(PILAR="MULTIFOCAIS")

SHARE_VARILUX_MM_2 <-
  rbind(SHARE_VARILUX_MM,SHARE_MULTIFOCAIS_MM) %>% 
  group_by(MES) %>% 
  summarize(SHARE=sum(SHARE[PILAR=='VARILUX'])/sum(SHARE[PILAR=='MULTIFOCAIS'])) 

SHARE_VARILUX_YTD <-
  df2   %>%  filter(PILARES=='VARILUX') %>% 
   group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
    summarize(SHARE = round(sum(VRVENDA),3)) %>% mutate(PILAR="VARILUX")


SHARE_MULTIFOCAIS_YTD <-
df2   %>%  filter(TIPO=='MULTIFOCAIS') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>%  mutate(PILAR="MULTIFOCAIS")


rbind(SHARE_VARILUX_YTD,SHARE_MULTIFOCAIS_YTD) %>% 
  group_by(ANO) %>% 
   summarize(SHARE=sum(SHARE[PILAR=='VARILUX'])/sum(SHARE[PILAR=='MULTIFOCAIS'])) 






## SHARE KODAK ==============================================================

## MM 

SHARE_KODAK_MM <-
  df2   %>%  filter(PILARES=='KODAK') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>% mutate(PILAR="KODAK")


SHARE_LENTES_MM <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>%  mutate(PILAR="LENTES")

SHARE_KODAK_MM_2 <-
rbind(SHARE_KODAK_MM,SHARE_LENTES_MM) %>% 
  group_by(MES) %>% 
  summarize(SHARE=sum(SHARE[PILAR=='KODAK'])/sum(SHARE[PILAR=='LENTES'])) 

## YTD

SHARE_KODAK_YTD <-
  df2   %>%  filter(PILARES=='KODAK') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>% mutate(PILAR="KODAK")


SHARE_LENTES_YTD <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>%  mutate(PILAR="LENTES")


SHARE_KODAK_YTD_2 <-
rbind(SHARE_KODAK_YTD,SHARE_LENTES_YTD) %>% 
  group_by(ANO) %>% 
  summarize(SHARE=sum(SHARE[PILAR=='KODAK'])/sum(SHARE[PILAR=='LENTES'])) 
    

## SHARE TRANSITIONS  ==============================================================

## MM 

SHARE_TRANSITIONS_MM <-
  df2   %>%  filter(TRANSITIONS=='TRANSITIONS') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(SHARE = round(sum(QTD),3)) %>% mutate(PILAR="TRANSITIONS")


SHARE_LENTES_QTD_MM <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(SHARE = round(sum(QTD),3)) %>%  mutate(PILAR="LENTES")

SHARE_TRANSITIONS_MM_2 <-
rbind(SHARE_TRANSITIONS_MM,SHARE_LENTES_QTD_MM) %>% 
  group_by(MES) %>% 
  summarize(SHARE=sum(SHARE[PILAR=='TRANSITIONS'])/sum(SHARE[PILAR=='LENTES'])) 

## YTD

SHARE_TRANSITIONS_YTD <-
  df2   %>%  filter(TRANSITIONS=='TRANSITIONS') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(SHARE = round(sum(QTD),3)) %>% mutate(PILAR="TRANSITIONS")


SHARE_LENTES_QTD_YTD <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(SHARE = round(sum(QTD),3)) %>%  mutate(PILAR="LENTES")

SHARE_TRANSITIONS_YTD_2 <-
rbind(SHARE_TRANSITIONS_YTD,SHARE_LENTES_QTD_YTD) %>% 
  group_by(ANO) %>% 
  summarize(SHARE=sum(SHARE[PILAR=='TRANSITIONS'])/sum(SHARE[PILAR=='LENTES'])) 


## SHARE CRIZAL  ==============================================================

## MM 

SHARE_CRIZAL_MM <-
  df2   %>%  filter(PILARES=='CRIZAL VS') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(SHARE = round(sum(QTD),3)) %>% mutate(PILAR="CRIZAL")


SHARE_LA_QTD_MM <-
  df2   %>%  filter(TIPO=="LENTES ACABADAS") %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(SHARE = round(sum(QTD),3)) %>%  mutate(PILAR="LA")

SHARE_CRIZAL_MM_2 <-
rbind(SHARE_CRIZAL_MM,SHARE_LA_QTD_MM) %>% 
  group_by(MES) %>% 
  summarize(SHARE=sum(SHARE[PILAR=='CRIZAL'])/sum(SHARE[PILAR=='LA'])) 

## YTD

SHARE_CRIZAL_YTD <-
  df2   %>%  filter(PILARES=='CRIZAL VS') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(SHARE = round(sum(QTD),3)) %>% mutate(PILAR="CRIZAL")


SHARE_LA_QTD_YTD <-
  df2   %>%  filter(TIPO=="LENTES ACABADAS") %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(SHARE = round(sum(QTD),3)) %>%  mutate(PILAR="LA")

SHARE_CRIZAL_YTD_2 <-
rbind(SHARE_CRIZAL_YTD,SHARE_LA_QTD_YTD) %>% 
  group_by(ANO) %>% 
  summarize(SHARE=sum(SHARE[PILAR=='CRIZAL'])/sum(SHARE[PILAR=='LA'])) 


## SHARE MARCAS REPRO  ==============================================================

## MM 

SHARE_MREPRO_MM <-
  df2   %>%  filter(MPROPRIA=='M REPRO') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>% mutate(PILAR="M REPRO")


SHARE_VLENTES_MM <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>%  mutate(PILAR="V LENTES")

SHARE_MREPRO_MM_2 <-
rbind(SHARE_MREPRO_MM,SHARE_VLENTES_MM) %>% 
  group_by(MES) %>% 
  summarize(SHARE=sum(SHARE[PILAR=='M REPRO'])/sum(SHARE[PILAR=='V LENTES'])) 

## YTD

SHARE_MREPRO_YTD <-
  df2   %>%  filter(MPROPRIA=='M REPRO') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>% mutate(PILAR='M REPRO')


SHARE_VLENTES_YTD <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(SHARE = round(sum(VRVENDA),3)) %>%  mutate(PILAR='V LENTES')

SHARE_MREPRO_YTD_2 <- 
rbind(SHARE_MREPRO_YTD,SHARE_VLENTES_YTD) %>% 
  group_by(ANO) %>% 
  summarize(SHARE=sum(SHARE[PILAR=='M REPRO'])/sum(SHARE[PILAR=='V LENTES'])) 




## SHARE CRIZAL  ==============================================================


SHARE_VARILUX <-
  df2   %>%  filter(PILARES=='VARILUX') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year"),PILARES) %>%  
  summarize(
    SHARE = round(sum(VRVENDA) / sum(.$VRVENDA[floor_date(.$PEDDTBAIXA, "year") == 
                                                 floor_date(PEDDTBAIXA, "year") & 
                                                 floor_date(.$PEDDTBAIXA, "year") == 
                                                 floor_date(PEDDTBAIXA, "year")]), 3)) %>% 
  melt(.,id.vars = c("ANO", "PILARES"),variable.name = "METRICA",value.name = "VALOR")


## SHARE PILARES
  
  
SHARE_PILARES <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year"),PILARES) %>%  
  summarize(
            SHARE = round(sum(VRVENDA) / sum(.$VRVENDA[floor_date(.$PEDDTBAIXA, "year") == 
                                                                floor_date(PEDDTBAIXA, "year") & 
                                                                floor_date(.$PEDDTBAIXA, "year") == 
                                                   floor_date(PEDDTBAIXA, "year")]), 3)) %>% 
  melt(.,id.vars = c("ANO", "PILARES"),variable.name = "METRICA",value.name = "VALOR")


SALES_PILARES <-
  df2 %>%  mutate(LENTES=str_trim(LENTES)) %>% filter(LENTES=='LENTES') %>% 
  filter(PEDDTBAIXA %within% 
           interval(cut((Sys.Date()-1)-years(1),"month"),(Sys.Date()-1)-years(1))
         | PEDDTBAIXA  %within% interval(cut((Sys.Date()-1),"month"),Sys.Date()-1)) %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month"),PILARES) %>%  
  summarize(VENDAS=sum(VRVENDA)) %>% as.data.frame() %>% mutate(VAR=VENDAS/lag(VENDAS,7)-1)


## SHARE PILARES

SHARE_TRANSITIONS <-
  df2 %>% mutate(LENTES=str_trim(LENTES)) %>% filter(LENTES=='LENTES') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month"),TRANSITIONS) %>%  
  summarize(
    SHARE = round(sum(VRVENDA) / sum(.$VRVENDA[floor_date(.$PEDDTBAIXA, "year") == 
                                                 floor_date(PEDDTBAIXA, "year") & 
                                                 floor_date(.$PEDDTBAIXA, "month") == 
                                                 floor_date(PEDDTBAIXA, "month")]), 3)) %>% 
  melt(.,id.vars = c("MES", "TRANSITIONS"),variable.name = "METRICA",value.name = "VALOR") %>% 
  rename(PILARES=2) %>% as.data.frame() %>% filter(PILARES=='TRANSITIONS')



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


PILARES4 <- rbind(SHARE_PILARES,SHARE_TRANSITIONS,PILARES3) %>% filter(!is.na(VALOR))

view(PILARES4)



range_write("1AaPXqa1zDw8rDY2o7uyniDIm5VpyJo4j7sZ2bHX8jE0", range = "A:G",data = PILARES4, sheet = "DADOS2",reformat = FALSE)



