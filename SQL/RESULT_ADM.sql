-- DADOS DASHBOARD ADM

WITH FIS AS (SELECT FISCODIGO 
                     FROM TBFIS 
                      WHERE FISTPNATOP IN ('V','R','SR')),

SETOR AS (SELECT ZOCODIGO,
                  ZODESCRICAO 
                   FROM ZONA 
                    WHERE ZOCODIGO IN (20,21,22,23,24,25,26,27,28)),

ENDE AS (SELECT ENDCODIGO,
                 CLICODIGO,
                  ZODESCRICAO SETOR
                   FROM ENDCLI 
                    INNER JOIN SETOR ON ENDCLI.ZOCODIGO=SETOR.ZOCODIGO WHERE ENDFAT='S'),

PEDEMIS AS (SELECT ID_PEDIDO,
                    PEDDTEMIS,
                     PEDDTBAIXA,
                      SETOR
                       FROM PEDID 
                        INNER JOIN FIS ON PEDID.FISCODIGO1=FIS.FISCODIGO
                         INNER JOIN ENDE ON PEDID.CLICODIGO=ENDE.CLICODIGO AND PEDID.ENDCODIGO=ENDE.ENDCODIGO
                          WHERE 
                           (PEDDTEMIS BETWEEN (CURRENT_DATE) - EXTRACT(DAY FROM (CURRENT_DATE)) + 1 AND 'TODAY' OR
                            PEDDTEMIS BETWEEN DATEADD(-1 YEAR TO (CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 1)
                              AND DATEADD(-1 YEAR TO (CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 32 - 
                                EXTRACT(DAY FROM (CURRENT_DATE) - EXTRACT(DAY FROM (CURRENT_DATE)) + 32)))   AND 
                                  PEDSITPED<>'C' AND 
                                    PEDLCFINANC IN ('S', 'L','N')),
                                      
PEDBAIXA AS (SELECT ID_PEDIDO,
                     PEDDTEMIS,
                      PEDDTBAIXA,
                       SETOR
                        FROM PEDID 
                         INNER JOIN FIS ON PEDID.FISCODIGO1=FIS.FISCODIGO
                          INNER JOIN ENDE ON PEDID.CLICODIGO=ENDE.CLICODIGO AND PEDID.ENDCODIGO=ENDE.ENDCODIGO
                           WHERE 
                            (PEDDTBAIXA BETWEEN (CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 1 AND 'TODAY' OR
                              PEDDTBAIXA BETWEEN DATEADD(-1 YEAR TO (CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 1)
                               AND DATEADD(-1 YEAR TO (CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 32 - 
                                EXTRACT(DAY FROM (CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 32))) AND 
                                     PEDSITPED<>'C' AND 
                                      PEDLCFINANC IN ('S', 'L','N')),
                                      
                                      
                    PEDEMIS_YTD AS (SELECT ID_PEDIDO,
                        PEDDTEMIS,
                         PEDDTBAIXA,
                          'GERAL' SETOR
                           FROM PEDID 
                            INNER JOIN FIS ON PEDID.FISCODIGO1=FIS.FISCODIGO
                             INNER JOIN ENDE ON PEDID.CLICODIGO=ENDE.CLICODIGO AND PEDID.ENDCODIGO=ENDE.ENDCODIGO
                              WHERE 
                               PEDDTEMIS
                                BETWEEN 
                                 CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE) AND
                                  DATEADD(DAY, -EXTRACT(DAY FROM CURRENT_DATE), CURRENT_DATE) AND
                                   PEDSITPED<>'C' AND 
                                    PEDLCFINANC IN ('S', 'L','N')),
                                  
                                  
                      PEDBAIXA_YTD AS (SELECT ID_PEDIDO,
                        PEDDTEMIS,
                         PEDDTBAIXA,
                          'GERAL' SETOR
                           FROM PEDID 
                            INNER JOIN FIS ON PEDID.FISCODIGO1=FIS.FISCODIGO
                             INNER JOIN ENDE ON PEDID.CLICODIGO=ENDE.CLICODIGO AND PEDID.ENDCODIGO=ENDE.ENDCODIGO
                              WHERE 
                               PEDDTBAIXA
                                BETWEEN CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE) AND
                                 DATEADD(DAY, -EXTRACT(DAY FROM CURRENT_DATE), CURRENT_DATE) AND
                                  PEDSITPED<>'C' AND 
                                   PEDLCFINANC IN ('S', 'L','N'))
                 
SELECT
        PEDDTEMIS,
         CAST('EMISSAO' AS VARCHAR(10)) TIPO,
          SETOR, 
           SUM(PDPUNITLIQUIDO*PDPQTDADE)VRVENDA 
            FROM PDPRD PD
             INNER JOIN PEDEMIS PE ON PD.ID_PEDIDO=PE.ID_PEDIDO
              GROUP BY 1,2,3
              
UNION

                           
SELECT
        PEDDTBAIXA,
         CAST ('BAIXA'AS VARCHAR(10)) TIPO,
          SETOR, 
           SUM(PDPUNITLIQUIDO*PDPQTDADE)VRVENDA 
            FROM PDPRD PD
             INNER JOIN PEDBAIXA PX ON PD.ID_PEDIDO=PX.ID_PEDIDO
              GROUP BY 1,2,3  
              
              
UNION

                           
SELECT
        PEDDTEMIS,
         CAST ('EMISSAO'AS VARCHAR(10)) TIPO,
          SETOR, 
           SUM(PDPUNITLIQUIDO*PDPQTDADE)VRVENDA 
            FROM PDPRD PD
             INNER JOIN PEDEMIS_YTD PX ON PD.ID_PEDIDO=PX.ID_PEDIDO
              GROUP BY 1,2,3
              
UNION

                           
SELECT
        PEDDTBAIXA,
         CAST ('BAIXA'AS VARCHAR(10)) TIPO,
          SETOR, 
           SUM(PDPUNITLIQUIDO*PDPQTDADE)VRVENDA 
            FROM PDPRD PD
             INNER JOIN PEDBAIXA_YTD PX ON PD.ID_PEDIDO=PX.ID_PEDIDO
              GROUP BY 1,2,3
             
 