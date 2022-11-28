library(DBI)
library(tidyverse)
library(gmailr)

con2 <- dbConnect(odbc::odbc(), "reproreplica")


netsales <- dbGetQuery(con2, statement = read_file("C:\\Users\\Repro\\Documents\\R\\ADM\\BASES_AUTO\\SQL\\NETSALES.sql"))




##  SEND EMAIL  ==============================================================================================


filewd_mail_netsales <-  paste0("G:\\Meu Drive\\BACKUPS_FILIAIS\\NETSALES","_",format(Sys.Date(),"%d_%m_%y"),".csv")


write.csv2(netsales, file = filewd_mail_netsales ,row.names=FALSE)


