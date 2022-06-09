##  ATUALIZADOR BASE DE ACORDOS 
## 09.06.2022
## SANDRO JAKOSKA

library(DBI)
library(magrittr)
library(googlesheets4)
con2 <- dbConnect(odbc::odbc(), "reproreplica")



base_acordos_cli <- dbGetQuery(con2,"
           SELECT 
            C.CLICODIGO CODIGO_REPRO,
             C.GCLCODIGO CODIGO_GRUPO,
             GCLNOME NOME_GRUPO,
              CLIRAZSOCIAL RAZAO_SOCIAL,
               CLINOMEFANT NOME_FANTASIA,
                CLICNPJCPF CNPJ_CPF,
                 ZODESCRICAO SETOR,
                  ZOCODIGO COD_SETOR,
                   CIDNOME CIDADE,
                   CLIDTCAD
           FROM CLIEN C
           LEFT JOIN GRUPOCLI G ON G.GCLCODIGO=C.GCLCODIGO 
           LEFT JOIN (SELECT CLICODIGO,E.ZOCODIGO,ZODESCRICAO,CIDNOME FROM ENDCLI E
                                        LEFT JOIN ZONA Z ON E.ZOCODIGO=Z.ZOCODIGO
                                        LEFT JOIN CIDADE C ON C.CIDCODIGO=E.CIDCODIGO
                                        WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
           WHERE CLICLIENTE='S'
           ") 


range_write("1dvMlHa-jPpRf6Jtc-G-oYqrEzofdSO7g2tfxgmGOI5g",data=base_acordos_cli,sheet = "CLIENTES",
            range = "A1",reformat = FALSE) 