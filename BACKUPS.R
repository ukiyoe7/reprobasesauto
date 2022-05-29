
## BACKUP DE TABELAS
## 05.2022
## SANDRO JAKOSKA

## LIBRARIES =======================================================================

library(tidyverse)
library(lubridate)
library(reshape2)
library(DBI)
library(googlesheets4)

## DB CONNECTION ====================================================================

con2 <- dbConnect(odbc::odbc(), "reproreplica")

## CLITBP ==========================================================================

clitbp <- dbGetQuery(con2,"
SELECT * FROM CLITBP
")



clitbp_wd <-  paste0("G:\\Meu Drive\\BACKUPS\\CLITBP","_",format(Sys.Date(),"%d_%m_%y"),".csv")

write.csv2(clitbp, file = clitbp_wd,row.names=FALSE)

## TABPRECO ==========================================================================

tabpreco <- dbGetQuery(con2,"
SELECT * FROM TABPRECO
")


tabpreco_wd <-  paste0("G:\\Meu Drive\\BACKUPS\\TABPRECO","_",format(Sys.Date(),"%d_%m_%y"),".csv")

write.csv2(tabpreco, file = tabpreco_wd,row.names=FALSE)

## TBPPRODU ==========================================================================

tbpprodu <- dbGetQuery(con2,"
SELECT * FROM TBPPRODU
")



tbpprodu_wd <-  paste0("G:\\Meu Drive\\BACKUPS\\TBPPRODU","_",format(Sys.Date(),"%d_%m_%y"),".csv")

write.csv2(tbpprodu, file = tbpprodu_wd,row.names=FALSE)


## CLITBPCOMB ==========================================================================

clitbpcomb <- dbGetQuery(con2,"
SELECT * FROM CLITBPCOMB
")



clitbpcomb_wd <-  paste0("G:\\Meu Drive\\BACKUPS\\CLITBPCOMB","_",format(Sys.Date(),"%d_%m_%y"),".csv")

write.csv2(clitbpcomb, file = clitbpcomb_wd,row.names=FALSE)


## TBPCOMBPROPRO ==========================================================================

tbpcombpropro <- dbGetQuery(con2,"
SELECT * FROM TBPCOMBPROPRO
")



tbpcombpropro_wd <- paste0("G:\\Meu Drive\\BACKUPS\\TBPCOMBPROPRO","_",format(Sys.Date(),"%d_%m_%y"),".csv")

write.csv2(tbpcombpropro, file = tbpcombpropro_wd,row.names=FALSE)


## CLIEN ==========================================================================

clien <- dbGetQuery(con2,"
  SELECT * FROM CLIEN WHERE CLICLIENTE='S'
")


clien_wd <- paste0("G:\\Meu Drive\\BACKUPS\\CLIEN","_",format(Sys.Date(),"%d_%m_%y"),".csv")

write.csv2(clien, file = clien_wd,row.names=FALSE)





