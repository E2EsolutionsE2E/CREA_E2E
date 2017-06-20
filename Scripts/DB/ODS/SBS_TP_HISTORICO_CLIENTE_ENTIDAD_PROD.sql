/*truncate SBS_ODS_SALDO;
truncate SBS_ODS_CLIENTE;
--truncate SBS_STG_CLIENTE;
--truncate SBS_STG_SALDO;
--truncate SBS_ODS_PRODUCTO;
--truncate SBS_ODS_REL_PRODUCTO;
truncate SBS_DIM_CLIENTE;
truncate SBS_DIM_CUENTA;
--truncate SBS_DIM_ENTIDAD;
--truncate SBS_DIM_PRODUCTO;
--truncate SBS_DIM_UBIGEO;
truncate SBS_FACT_CLIENTE;
truncate SBS_FACT_SALDO;
truncate SBS_FACT_CLIENTE_ENTIDAD_PROD;
truncate SBS_FACT_CLIENTE_ENTIDAD;*/

--HISTORICO
DROP TABLE IF EXISTS TP_COSECHA_CLI_ENT_PROD;

@@@

create table TP_COSECHA_CLI_ENT_PROD
(
  COD_CLIENTE_SBS NUMERIC(18,2) not null,
  COD_ENTIDAD     VARCHAR(10) not null,
  COD_SUBPRODUCTO VARCHAR(10) not null,
  MINPERIODO      NUMERIC(18,2),
  MTO_SALDO       NUMERIC(18,2)
);

@@@

--HISTORICA X UNICA VEZ
INSERT INTO  TP_COSECHA_CLI_ENT_PROD
SELECT A.COD_CLIENTE_SBS, A.COD_ENTIDAD, B.COD_SUBPRODUCTO ,A.MINPERIODO, SUM(B.MTO_SALDO) AS MTO_SALDO
    FROM (SELECT   COD_CLIENTE_SBS,  COD_ENTIDAD, COD_SUBPRODUCTO, MIN(COD_PERIODO) AS MINPERIODO 
          FROM SBS_FACT_SALDO 
        GROUP BY COD_CLIENTE_SBS,  COD_ENTIDAD, COD_SUBPRODUCTO) A
          INNER JOIN SBS_FACT_SALDO B
    ON A.COD_CLIENTE_SBS = B.COD_CLIENTE_SBS
    AND A.COD_ENTIDAD = B.COD_ENTIDAD
    AND A.COD_SUBPRODUCTO = B.COD_SUBPRODUCTO 
    AND A.MINPERIODO = B.COD_PERIODO
 GROUP BY
 A.COD_CLIENTE_SBS, 
 A.COD_ENTIDAD, 
 B.COD_SUBPRODUCTO,
 A.MINPERIODO;
 
 
 