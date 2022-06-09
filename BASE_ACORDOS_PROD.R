## TABELA DE PREÇOS 
## SANDRO JAKOSKA

library(DBI)
library(tidyverse)
library(lubridate)
library(googlesheets4)
con2 <- dbConnect(odbc::odbc(), "reproreplica")



base_acordos_prod <- dbGetQuery(con2,"
           WITH PRECO AS(SELECT PROCODIGO,PREPCOVENDA,PREPCOVENDA2 FROM PREMP WHERE EMPCODIGO=1)
           
           SELECT PRD.PROCODIGO,
                       PRODESCRICAO DESCRICAO,
                        IIF(PROUN='PC',PREPCOVENDA*2,PREPCOVENDA) PARATC,
                         IIF(PROUN='PC',PREPCOVENDA2*2,PREPCOVENDA2) PARLAB,
                          PROUN UNIDADE,
                            PROTIPO TIPO,
                             MARNOME MARCA,
                              GR1DESCRICAO TIPO2
           FROM PRODU PRD
           INNER JOIN PRECO P ON PRD.PROCODIGO=P.PROCODIGO
           LEFT JOIN MARCA M ON PRD.MARCODIGO=M.MARCODIGO
           LEFT JOIN GRUPO1 G1 ON PRD.GR1CODIGO=G1.GR1CODIGO
           WHERE PRD.GR1CODIGO<>17 AND PROSITUACAO='A'
           AND PROCODIGO2 IS NULL
           AND PROTIPO NOT IN ('W','1','Z','S','X','I','E','K')
           ") %>% mutate(PROCODIGO=trimws(PROCODIGO))




range_write("1dvMlHa-jPpRf6Jtc-G-oYqrEzofdSO7g2tfxgmGOI5g",data=base_acordos_prod,sheet = "PRECOS",
            range = "A1",reformat = FALSE) 