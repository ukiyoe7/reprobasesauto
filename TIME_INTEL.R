


## YTD YESTERDAY
dbGetQuery(con2,"
           SELECT DISTINCT PEDDTEMIS
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE) AND
                                  'YESTERDAY'") %>% View()


## YTD LAST MONTH
dbGetQuery(con2,"
           SELECT DISTINCT PEDDTEMIS
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE) AND
                                  DATEADD(DAY, -EXTRACT(DAY FROM CURRENT_DATE), CURRENT_DATE)") %>% View()



## YTD LAST YEAR LAST MONTH
dbGetQuery(con2,"
           SELECT DISTINCT PEDDTEMIS
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             DATEADD(YEAR, -1, CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE)) AND
                                  DATEADD(YEAR, -1,DATEADD(DAY, -EXTRACT(DAY FROM CURRENT_DATE), CURRENT_DATE))") %>% View()



## YTD LAST YEAR CURRENT MONTH YESTERDAY
dbGetQuery(con2,"
           SELECT DISTINCT PEDDTEMIS
           FROM PEDID
           WHERE
           PEDDTEMIS BETWEEN
             DATEADD(YEAR, -1, CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE)) AND
                                  DATEADD(YEAR, -1, CURRENT_DATE-1)") %>% View()


