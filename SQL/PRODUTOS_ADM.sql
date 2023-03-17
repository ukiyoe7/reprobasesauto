-- DADOS DASHBOARD ADM

WITH FIS AS (SELECT FISCODIGO 
                     FROM TBFIS 
                      WHERE FISTPNATOP IN ('V','R','SR')),


DATE_PED AS (SELECT ID_PEDIDO 
                      FROM PEDID WHERE
                               (PEDDTBAIXA BETWEEN (CURRENT_DATE) - EXTRACT(DAY FROM (CURRENT_DATE)) + 1 AND 'TODAY' OR
                                 PEDDTBAIXA BETWEEN DATEADD(-1 YEAR TO (CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 1)
                                  AND DATEADD(-1 YEAR TO (CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 32 - 
                                   EXTRACT(DAY FROM (CURRENT_DATE) - EXTRACT(DAY FROM (CURRENT_DATE)) + 32)))),


PED AS (SELECT P.ID_PEDIDO,
                    PEDDTBAIXA
                     FROM PEDID P
                      INNER JOIN FIS ON P.FISCODIGO1=FIS.FISCODIGO
                       INNER JOIN DATE_PED DTP ON P.ID_PEDIDO=DTP.ID_PEDIDO
                         WHERE PEDSITPED<>'C' AND 
                                    PEDLCFINANC IN ('S', 'L','N')),

-- PILARES
PILARES AS (SELECT PROCODIGO,
                       CASE 
                   WHEN MARCODIGO=57 THEN 'VARILUX' 
                    WHEN PROCODIGO IN (SELECT PROCODIGO FROM NGRUPOS WHERE GRCODIGO=162) THEN 'M CLIENTE'
                     WHEN (MARCODIGO=24 AND GR2CODIGO=1) THEN 'KODAK MF'
                      WHEN (MARCODIGO=24 AND GR2CODIGO=3) THEN 'KODAK VS'
                      WHEN (MARCODIGO IN (106,128,135,158,159,189) AND PROTIPO<>'T') THEN 'M REPRO'
                       WHEN (PRODESCRICAO LIKE '%CRIZAL%' OR PRODESCRICAO LIKE '%C.FORTE%') AND GR1CODIGO=2 THEN 'CRIZAL VS'
                        WHEN (PRODESCRICAO LIKE '%CRIZAL%' AND PROTIPO='T') THEN 'TRAT CRIZAL'
                         ELSE 'OUTROS' 
                          END PILARES
                           FROM PRODU),  
                          
-- MULTIFOCAIS
MF AS (SELECT PROCODIGO,
                       CASE 
                        WHEN MARCODIGO=57 THEN 'VARILUX'
                         WHEN MARCODIGO=189 THEN 'INSIGNE'
                          WHEN MARCODIGO=135 THEN 'IMAGEM'
                           WHEN MARCODIGO=128 THEN 'UZ+'
                            WHEN MARCODIGO=158 THEN 'ACTUALITE'
                             WHEN MARCODIGO=159  THEN 'AVANCE'
                              WHEN PROCODIGO IN (SELECT PROCODIGO FROM NGRUPOS WHERE GRCODIGO=162) THEN 'MARCA CLIENTE'
                               WHEN MARCODIGO=24 THEN 'KODAK'
                                ELSE 'OUTROS' 
                                 END   MULTIFOCAIS
                                  FROM  PRODU WHERE GR2CODIGO=1), 
                                   
-- TRANSITIONS
TRANS AS (SELECT PROCODIGO,
                  CASE 
                   WHEN PRODESCRICAO LIKE '%TGEN8%' OR PRODESCRICAO LIKE '%TRANS%' THEN 'TRANSITIONS'
                    ELSE ''
                     END TRANSITIONS
                      FROM PRODU), 
                      
                      
-- LENTES
LENS AS (SELECT PROCODIGO,
                  CASE 
                   WHEN PROTIPO IN ('P','F','E') THEN 'LENTES'
                    ELSE 'SERVICOS'
                     END LENTES
                      FROM PRODU)
                                   
SELECT
   PEDDTBAIXA,
     PILARES,
      MULTIFOCAIS,
       TRANSITIONS,
        LENTES,
        PDPDESCRICAO,
         SUM(PDPQTDADE)QTD,
          SUM(PDPUNITLIQUIDO*PDPQTDADE)VRVENDA 
           FROM PDPRD PD
            INNER JOIN PED P ON PD.ID_PEDIDO=P.ID_PEDIDO
             LEFT JOIN PILARES PR ON PD.PROCODIGO=PR.PROCODIGO
              LEFT JOIN MF M ON PD.PROCODIGO=M.PROCODIGO
               LEFT JOIN TRANS T ON PD.PROCODIGO=T.PROCODIGO
                LEFT JOIN LENS L ON PD.PROCODIGO=L.PROCODIGO
                 GROUP BY 1,2,3,4,5,6
              
             
             