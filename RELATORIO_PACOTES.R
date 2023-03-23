## 
## BASE ATUALIZAÇÃO RELATORIO PACOTES



library(DBI)
library(tidyverse)
library(googlesheets4)


con2 <- dbConnect(odbc::odbc(), "reproreplica")


dfpct1 <- dbGetQuery(con2, statement = read_file("C:\\Users\\Repro\\Documents\\R\\ADM\\BASES_AUTO\\SQL\\SALDO_PACOTES.sql"))
dfpct2 <- dbGetQuery(con2, statement = read_file("C:\\Users\\Repro\\Documents\\R\\ADM\\BASES_AUTO\\SQL\\CONSUMO_PACOTES.sql"))
dfpct3 <- dbGetQuery(con2, statement = read_file("C:\\Users\\Repro\\Documents\\R\\ADM\\BASES_AUTO\\SQL\\DEVOLUCAO_PACOTES.sql"))



range_write("1EqLttJ74cEaDro1FrEeJ1hSyp-qF5GjeAwNVvziwOXs", data = dfpct1,range ="A:P" ,sheet = "BASE 192",reformat = FALSE)

range_write("1EqLttJ74cEaDro1FrEeJ1hSyp-qF5GjeAwNVvziwOXs", data = dfpct2,range ="B:J" ,sheet = "CONSUMO 243 - MES VIGENTE",reformat = FALSE)

range_write("1EqLttJ74cEaDro1FrEeJ1hSyp-qF5GjeAwNVvziwOXs", data = dfpct3,range ="A:F" ,sheet = "DEVOLUÇÕES 288 - ANO TODO",reformat = FALSE)




