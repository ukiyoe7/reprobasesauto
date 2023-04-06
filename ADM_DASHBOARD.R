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
  summarize(VALOR = round(sum(VRVENDA),3)) %>% mutate(PILAR="VARILUX")


SHARE_MULTIFOCAIS_MM <-
  df2   %>%  filter(TIPO=='MULTIFOCAIS') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = round(sum(VRVENDA),3)) %>%  mutate(PILAR="MULTIFOCAIS")

SHARE_VARILUX_MM_2 <-
  rbind(SHARE_VARILUX_MM,SHARE_MULTIFOCAIS_MM) %>% 
  group_by(MES) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='VARILUX'])/sum(VALOR[PILAR=='MULTIFOCAIS'])) %>% 
  mutate(VALOR=round(VALOR,3)) %>% 
  mutate(PILAR='VARILUX') %>% 
  mutate(METRICA='SHARE') %>% 
  mutate(PERIODO='MES') %>% 
   rename(DATA=1)


SHARE_VARILUX_YTD <-
  df2   %>%  filter(PILARES=='VARILUX') %>% 
   group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
    summarize(VALOR = round(sum(VRVENDA),3)) %>% mutate(PILAR="VARILUX")


SHARE_MULTIFOCAIS_YTD <-
df2   %>%  filter(TIPO=='MULTIFOCAIS') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = round(sum(VRVENDA),3)) %>%  mutate(PILAR="MULTIFOCAIS")

SHARE_VARILUX_YTD_2 <-
 rbind(SHARE_VARILUX_YTD,SHARE_MULTIFOCAIS_YTD) %>% 
  group_by(ANO) %>% 
   summarize(VALOR=sum(VALOR[PILAR=='VARILUX'])/sum(VALOR[PILAR=='MULTIFOCAIS'])) %>% 
    mutate(VALOR=round(VALOR,3)) %>% 
     mutate(PILAR='VARILUX') %>% 
      mutate(METRICA='SHARE') %>% 
       mutate(PERIODO='YTD') %>% 
        rename(DATA=1)
       



## SHARE KODAK ==============================================================

## MM 

SHARE_KODAK_MM <-
  df2   %>%  filter(PILARES=='KODAK') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = round(sum(VRVENDA),3)) %>% mutate(PILAR="KODAK")


SHARE_LENTES_MM <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = round(sum(VRVENDA),3)) %>%  mutate(PILAR="LENTES")

SHARE_KODAK_MM_2 <-
rbind(SHARE_KODAK_MM,SHARE_LENTES_MM) %>% 
  group_by(MES) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='KODAK'])/sum(VALOR[PILAR=='LENTES'])) %>% 
   mutate(VALOR=round(VALOR,3)) %>% 
    mutate(PILAR='KODAK') %>% 
     mutate(METRICA='SHARE') %>% 
      mutate(PERIODO='MES') %>% 
       rename(DATA=1)

## YTD

SHARE_KODAK_YTD <-
  df2   %>%  filter(PILARES=='KODAK') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = round(sum(VRVENDA),3)) %>% mutate(PILAR="KODAK")


SHARE_LENTES_YTD <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = round(sum(VRVENDA),3)) %>%  mutate(PILAR="LENTES")


SHARE_KODAK_YTD_2 <-
rbind(SHARE_KODAK_YTD,SHARE_LENTES_YTD) %>% 
  group_by(ANO) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='KODAK'])/sum(VALOR[PILAR=='LENTES'])) %>%
   mutate(VALOR=round(VALOR,3)) %>% 
    mutate(PILAR='KODAK') %>% 
     mutate(METRICA='SHARE') %>% 
      mutate(PERIODO='YTD') %>% 
       rename(DATA=1)
    

## SHARE TRANSITIONS  ==============================================================

## MM 

SHARE_TRANSITIONS_MM <-
  df2   %>%  filter(TRANSITIONS=='TRANSITIONS') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = round(sum(QTD),3)) %>% mutate(PILAR="TRANSITIONS")


SHARE_LENTES_QTD_MM <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = round(sum(QTD),3)) %>%  mutate(PILAR="LENTES")

SHARE_TRANSITIONS_MM_2 <-
rbind(SHARE_TRANSITIONS_MM,SHARE_LENTES_QTD_MM) %>% 
  group_by(MES) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='TRANSITIONS'])/sum(VALOR[PILAR=='LENTES'])) %>% 
   mutate(VALOR=round(VALOR,3)) %>% 
    mutate(PILAR='TRANSITIONS') %>% 
     mutate(METRICA='SHARE') %>% 
      mutate(PERIODO='MES') %>% 
       rename(DATA=1)

## YTD

SHARE_TRANSITIONS_YTD <-
  df2   %>%  filter(TRANSITIONS=='TRANSITIONS') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = round(sum(QTD),3)) %>% mutate(PILAR="TRANSITIONS")


SHARE_LENTES_QTD_YTD <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = round(sum(QTD),3)) %>%  mutate(PILAR="LENTES")

SHARE_TRANSITIONS_YTD_2 <-
rbind(SHARE_TRANSITIONS_YTD,SHARE_LENTES_QTD_YTD) %>% 
  group_by(ANO) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='TRANSITIONS'])/sum(VALOR[PILAR=='LENTES'])) %>% 
   mutate(VALOR=round(VALOR,3)) %>% 
    mutate(PILAR='TRANSITIONS') %>% 
     mutate(METRICA='SHARE') %>% 
      mutate(PERIODO='YTD') %>% 
       rename(DATA=1)


## SHARE CRIZAL  ==============================================================

## MM 

SHARE_CRIZAL_MM <-
  df2   %>%  filter(PILARES=='CRIZAL VS') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = round(sum(QTD),3)) %>% mutate(PILAR="CRIZAL")


SHARE_LA_QTD_MM <-
  df2   %>%  filter(TIPO=="LENTES ACABADAS") %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = round(sum(QTD),3)) %>%  mutate(PILAR="LA")

SHARE_CRIZAL_MM_2 <-
rbind(SHARE_CRIZAL_MM,SHARE_LA_QTD_MM) %>% 
  group_by(MES) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='CRIZAL'])/sum(VALOR[PILAR=='LA'])) %>% 
   mutate(VALOR=round(VALOR,3)) %>% 
    mutate(PILAR='CRIZAL') %>% 
     mutate(METRICA='SHARE') %>% 
      mutate(PERIODO='MES') %>% 
       rename(DATA=1)

## YTD

SHARE_CRIZAL_YTD <-
  df2   %>%  filter(PILARES=='CRIZAL VS') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = round(sum(QTD),3)) %>% mutate(PILAR="CRIZAL")


SHARE_LA_QTD_YTD <-
  df2   %>%  filter(TIPO=="LENTES ACABADAS") %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = round(sum(QTD),3)) %>%  mutate(PILAR="LA")

SHARE_CRIZAL_YTD_2 <-
rbind(SHARE_CRIZAL_YTD,SHARE_LA_QTD_YTD) %>% 
  group_by(ANO) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='CRIZAL'])/sum(VALOR[PILAR=='LA'])) %>% 
   mutate(VALOR=round(VALOR,3)) %>% 
    mutate(PILAR='CRIZAL') %>% 
     mutate(METRICA='SHARE') %>% 
      mutate(PERIODO='YTD') %>% 
       rename(DATA=1)


## SHARE MARCAS REPRO  ==============================================================

## MM 

SHARE_MREPRO_MM <-
  df2   %>%  filter(MPROPRIA=='M REPRO') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = sum(VRVENDA)) %>% mutate(PILAR="M REPRO")


SHARE_VLENTES_MM <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = sum(VRVENDA)) %>%  mutate(PILAR="V LENTES")

SHARE_MREPRO_MM_2 <-
rbind(SHARE_MREPRO_MM,SHARE_VLENTES_MM) %>% 
  group_by(MES) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='M REPRO'])/sum(VALOR[PILAR=='V LENTES'])) %>% 
   mutate(VALOR=round(VALOR,4)) %>% 
    mutate(PILAR='MARCAS REPRO') %>% 
     mutate(METRICA='SHARE') %>% 
      mutate(PERIODO='MES') %>% 
       rename(DATA=1)

## YTD

SHARE_MREPRO_YTD <-
  df2   %>%  filter(MPROPRIA=='M REPRO') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = VRVENDA) %>% mutate(PILAR='M REPRO')


SHARE_VLENTES_YTD <-
  df2   %>%  filter(LENTES=='LENTES') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = sum(VRVENDA)) %>%  mutate(PILAR='V LENTES')

SHARE_MREPRO_YTD_2 <- 
rbind(SHARE_MREPRO_YTD,SHARE_VLENTES_YTD) %>% 
  group_by(ANO) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='M REPRO'])/sum(VALOR[PILAR=='V LENTES'])) %>% 
   mutate(VALOR=round(VALOR,3)) %>% 
    mutate(PILAR='MARCAS REPRO') %>% 
     mutate(METRICA='SHARE') %>% 
      mutate(PERIODO='YTD') %>% 
       rename(DATA=1)


## SHARE MARCAS CLIENTES ==============================================================

## MM 

SHARE_MCLIENTES_MM <-
  df2   %>%  filter(MPROPRIA=='M CLIENTE') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = sum(VRVENDA)) %>% mutate(PILAR='M CLIENTE')


SHARE_VMPROPRIA_MM <-
  df2   %>%  filter(MPROPRIA %in% c('M CLIENTE','M REPRO')) %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VALOR = sum(VRVENDA)) %>%  mutate(PILAR="V MPROPRIA")

SHARE_MCLIENTES_MM_2 <-
  rbind(SHARE_MCLIENTES_MM,SHARE_VMPROPRIA_MM) %>% 
  group_by(MES) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='M CLIENTE'])/sum(VALOR[PILAR=='V MPROPRIA'])) %>% 
  mutate(VALOR=round(VALOR,4)) %>% 
  mutate(PILAR='MARCAS CLIENTES') %>% 
  mutate(METRICA='SHARE') %>% 
  mutate(PERIODO='MES') %>% 
  rename(DATA=1)

## YTD

SHARE_MCLIENTES_YTD <-
  df2   %>%  filter(MPROPRIA=='M CLIENTE') %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = VRVENDA) %>% mutate(PILAR='M CLIENTE')


SHARE_VMPROPRIA_YTD <-
  df2   %>%  filter(MPROPRIA %in% c('M CLIENTE','M REPRO')) %>% 
  group_by(ANO=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VALOR = sum(VRVENDA)) %>%  mutate(PILAR='V MPROPRIA')

SHARE_MCLIENTES_YTD_2 <- 
  rbind(SHARE_MCLIENTES_YTD,SHARE_VLENTES_YTD) %>% 
  group_by(ANO) %>% 
  summarize(VALOR=sum(VALOR[PILAR=='M CLIENTES'])/sum(VALOR[PILAR=='V MPROPRIA'])) %>% 
  mutate(VALOR=round(VALOR,3)) %>% 
  mutate(PILAR='MARCAS CLIENTES') %>% 
  mutate(METRICA='SHARE') %>% 
  mutate(PERIODO='YTD') %>% 
  rename(DATA=1)

## MERGE ALL  ==============================================================

share_pilares <-
  rbind(SHARE_VARILUX_MM_2,
         SHARE_KODAK_MM_2,
          SHARE_TRANSITIONS_MM_2,
           SHARE_CRIZAL_MM_2,
            SHARE_MREPRO_MM_2,
             SHARE_VARILUX_YTD_2,
              SHARE_KODAK_YTD_2,
               SHARE_TRANSITIONS_YTD_2,
                SHARE_CRIZAL_YTD_2,
                 SHARE_MREPRO_YTD_2)


range_write("1AaPXqa1zDw8rDY2o7uyniDIm5VpyJo4j7sZ2bHX8jE0", range = "A:I",data = share_pilares, sheet = "DADOS2",reformat = FALSE)


## VAR SALES  ==============================================================

VAR_VARILUX_MM <-
  df2   %>%  filter(PILARES=='VARILUX') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VOL = round(sum(QTD),as.numeric(format(Sys.Date(), "%m")))) %>% 
   mutate(VAR=VOL/lag(VOL,as.numeric(format(Sys.Date(), "%m")))-1) %>% 
  mutate(PILAR='VARILUX') %>% 
  mutate(METRICA='VAR') %>% 
  mutate(PERIODO='MES') %>% 
  rename(DATA=1)

VAR_VARILUX_YTD <-
  df2   %>%  filter(PILARES=='VARILUX') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"year")) %>%  
  summarize(VOL = round(sum(QTD),as.numeric(format(Sys.Date(), "%m")))) %>% 
  mutate(VAR=VOL/lag(VOL,as.numeric(format(Sys.Date(), "%m")))-1) %>% 
  mutate(PILAR='VARILUX') %>% 
  mutate(METRICA='VAR') %>% 
  mutate(PERIODO='YTD') %>% 
  rename(DATA=1)




VAR_KODAK_MM <-
  df2   %>%  filter(PILARES=='KODAK') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VOL = round(sum(QTD),as.numeric(format(Sys.Date(), "%m")))) %>% 
  mutate(VAR=VOL/lag(VOL,as.numeric(format(Sys.Date(), "%m")))-1)  %>% 
  mutate(PILAR='KODAK') %>% 
  mutate(METRICA='VAR') %>% 
  mutate(PERIODO='MES') %>% 
  rename(DATA=1)


VAR_CRIZAL_MM <-
  df2   %>%  filter(PILARES=='CRIZAL VS') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VOL = round(sum(QTD),as.numeric(format(Sys.Date(), "%m")))) %>% 
  mutate(VAR=VOL/lag(VOL,as.numeric(format(Sys.Date(), "%m")))-1)  %>% 
  mutate(PILAR='CRIZAL VS') %>% 
  mutate(METRICA='VAR') %>% 
  mutate(PERIODO='MES') %>% 
  rename(DATA=1)

VAR_TRANSITIONS_MM <-
  df2   %>%  filter(TRANSITIONS=='TRANSITIONS') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VOL = round(sum(QTD),as.numeric(format(Sys.Date(), "%m")))) %>% 
  mutate(VAR=VOL/lag(VOL,as.numeric(format(Sys.Date(), "%m")))-1)  %>% 
  mutate(PILAR='TRANSITIONS') %>% 
  mutate(METRICA='VAR') %>% 
  mutate(PERIODO='MES') %>% 
  rename(DATA=1)


VAR_MREPRO_MM <-
df2   %>%  filter(MPROPRIA=='M REPRO') %>% 
  group_by(MES=floor_date(PEDDTBAIXA,"month")) %>%  
  summarize(VOL = round(sum(QTD),as.numeric(format(Sys.Date(), "%m")))) %>% 
  mutate(VAR=VOL/lag(VOL,as.numeric(format(Sys.Date(), "%m")))-1)  %>% 
  mutate(PILAR='M REPRO') %>% 
  mutate(METRICA='VAR') %>% 
  mutate(PERIODO='MES') %>% 
  rename(DATA=1)



var_pilares <-
  rbind(VAR_VARILUX_MM,
        VAR_KODAK_MM,
        VAR_CRIZAL_MM,
        VAR_TRANSITIONS_MM,
        VAR_MREPRO_MM) %>% 
         filter(!is.na(VAR)) %>% 
          rename(VALOR=3) %>% .[,-2] %>% 
  mutate(VALOR=round(VALOR,4))


range_write("1AaPXqa1zDw8rDY2o7uyniDIm5VpyJo4j7sZ2bHX8jE0", range = "A52",
            data = var_pilares, sheet = "DADOS2",reformat = FALSE,
             col_names = FALSE)







