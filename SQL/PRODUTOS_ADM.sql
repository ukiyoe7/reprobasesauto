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

-- MULTIFOCAIS AND VS
PROD AS (SELECT PROCODIGO,
                  CASE 
                   WHEN GR2CODIGO=1 THEN 'MULTIFOCAL'
                    WHEN GR2CODIGO=3 THEN 'VISAO SIMPLES' 
                     ELSE 'OUTROS'
                      END CLASSE1,

                 CASE 
                   WHEN MARCODIGO IN (57,24) THEN 'ESSILOR' 
                     WHEN MARCODIGO IN (189,135,158,159) THEN 'MARCAS REPRO'
                        ELSE 'OUTROS' 
                         END CLASSE2, 

                  CASE 
                   WHEN MARCODIGO=57 THEN 'VARILUX' 
                    WHEN MARCODIGO=24 THEN 'KODAK'
                     WHEN MARCODIGO=189 THEN 'INSIGNE'
                      WHEN MARCODIGO=135 THEN 'IMAGEM'
                       WHEN MARCODIGO=158 THEN 'ACTUALITE'
                        WHEN MARCODIGO=159  THEN 'AVANCE'
                         WHEN MARCODIGO=1  THEN 'ESSILOR'
                         ELSE 'OUTROS' 
                           END CLASSE3 
                            FROM PRODU WHERE PROSITUACAO='A'
                             AND PROTIPO IN ('F','P'))
                             
                             

SELECT
 PEDDTBAIXA,
   CLASSE1,
    CLASSE2,
     CLASSE3,
      SUM(PDPQTDADE)QTD,
       SUM(PDPUNITLIQUIDO*PDPQTDADE)VRVENDA 
        FROM PDPRD PD
         INNER JOIN PED P ON PD.ID_PEDIDO=P.ID_PEDIDO
          INNER JOIN PROD PR ON PD.PROCODIGO=PR.PROCODIGO
            GROUP BY 1,2,3,4
              
             
             