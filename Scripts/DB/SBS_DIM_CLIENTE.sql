--*******
--PERIODO ACTUAL 201612
-- inicio el calculo aquellos registros que no estan en el periodo
DROP TABLE ACTUALIZAR;

@@@

create table ACTUALIZAR
(
  a_cod_cliente_sbs   NUMERIC(18,2) ,
  flag   varchar(1) --0 
);

@@@

INSERT INTO  ACTUALIZAR
--CON ESTE QUERY IDENTIFICO A LOS QUE SE DEBEN ACTUALIZAR CON LA INFORMACION DEL PERIODO(0) Y LOS QUE NO APARECEN EN EL PERIODO ACTUAL(1)
select 
a_cod_cliente_sbs,
flag
from (
SELECT 
a.COD_CLIENTE_SBS as a_cod_cliente_sbs,--
a.cod_periodo_ult as a_cod_periodo_ult,
b.cod_cliente_sbs,
case when b.cod_cliente_sbs is null then 1 else 0 end as flag,--
b.cod_periodo
FROM SBS_DIM_CLIENTE A
left  outer JOIN sbs_fact_cliente B ON a.COD_CLIENTE_SBS = b.COD_CLIENTE_SBS
and b.cod_periodo=@@p_cod_periodo@@) as princ; --el periodo se modifica???? 201612 mes actual

@@@

/*
select * from sbs_fact_cliente 
select * from sbs_dim_cliente
select * from ACTUALIZAR where flag='1';
--*******
--caso 1 el registro viene en el nuevo periodo y esta en la maestra
insert into sbs_fact_cliente (cod_periodo,cod_cliente_sbs)
values(201612,1);
insert into sbs_dim_cliente (cod_Cliente_sbs,COD_PERIODO_ULT)
values(1,201611);

--caso 2 no esta en la fact_cliente pero si esta en la maestra
insert into sbs_dim_cliente (cod_Cliente_sbs,COD_PERIODO_ULT)
values(2,201611);

insert into sbs_dim_cliente (cod_Cliente_sbs,COD_PERIODO_ULT)
values(4,201611);
--caso 3 si esta en la fact cliente pero no esta en la maestra
insert into sbs_fact_Cliente(cod_cliente_Sbs,cod_periodo)
values(3,201612);
insert into sbs_fact_Cliente(cod_cliente_Sbs,cod_periodo)
values(5,201612);

--**********************************

select * from sbs_fact_cliente ;
select * from sbs_dim_cliente

truncate table sbs_fact_cliente;
truncate table sbs_dim_cliente;

---fin para identificar a los codigos que no vinieron en el presente periodo
*/
--SBS_DIM_CLIENTE
--PASO 1, CREAR UN TEMPORAL PARA HACER UNA TABLA MAESTRA
DROP TABLE TP_SBS_DIM_CLIENTE;

@@@

CREATE TABLE TP_SBS_DIM_CLIENTE
( 
	COD_CLIENTE_SBS    NUMBER   NOT NULL ,
	TIP_DOCUMENTO_PRIN VARCHAR  NULL ,
	COD_DOCUMENTO_PRIN VARCHAR  NULL ,
	COD_CLIENTE_PROP   NUMBER   NULL ,
	TIP_DOCUMENTO_JUR  VARCHAR  NULL ,
	COD_DOCUMENTO_JUR  VARCHAR  NULL ,
	TIP_DOCUMENTO_NAT  VARCHAR  NULL ,
	COD_DOCUMENTO_NAT  VARCHAR  NULL ,
	TIP_PERSONA        VARCHAR  NULL ,
	COD_PERIODO_BANCARIZACION VARCHAR  NULL ,
	COD_PRODUCTO_BANCARIZACION NUMBER  NULL ,
	COD_ENTIDAD_BANCARIZACION NUMBER  NULL ,
	TIP_SITUACION_BANCARIZACION VARCHAR  NULL ,
	COD_PERIODO_COSECHA_PROP VARCHAR  NULL ,
	COD_PRODUCTO_COSECHA_PROP NUMBER  NULL ,
	COD_PERIODO_ULT_PROP VARCHAR  NULL ,
	TIP_SITUACION_PROP VARCHAR  NULL ,
	NOM_PRIMER_NOMBRE  VARCHAR  NULL ,
	NOM_SEGUNDO_NOMBRE VARCHAR  NULL ,
	NOM_APE_PATERNO    VARCHAR  NULL ,
	NOM_APE_MATERNO    VARCHAR  NULL ,
	CNT_CPPDDP_3M      NUMBER  NULL ,
	CNT_DDP_24M        NUMBER  NULL ,
	CNT_NORMAL_12M     NUMBER  NULL ,
	FLG_GARANTIA       VARCHAR  NULL ,
	FLG_SALDO_PMM_24M  NUMBER  NULL ,
	MTO_SALDO_PP_MAX_24M NUMBER  NULL ,
	MTO_LINEATC_MAX_24M NUMBER  NULL ,
	MTO_SALDO_PMM_MAX_24M NUMBER  NULL ,
	COD_PERIODO_SALDO_PP_MAX_24M VARCHAR  NULL ,
	COD_PERIODO_LINEATC_MAX_24M VARCHAR  NULL ,
	COD_PERIODO_PMM_MAX_24M VARCHAR  NULL ,
	COD_UBIGEO         VARCHAR(20)  NOT NULL ,
	COD_SEGMENTO_PROP  VARCHAR  NULL ,
	TIP_MUNDO_CONSUMO  VARCHAR  NULL ,
	MTO_INGRESO_CLI    NUMBER  NULL ,
	MTO_CUOTA_MES      NUMBER  NULL ,
	COD_PERIODO_ULT    char(18)  NULL ,
	TIP_CLASIFICACION_ULTMES char(18)  NULL ,
	TIP_MUNDO_PMM      char(18)  NULL ,
	TIP_MUNDO_HIP      char(18)  NULL
);

@@@

INSERT INTO TP_SBS_DIM_CLIENTE
SELECT * -- o mencionar todos los campos 
FROM SBS_DIM_CLIENTE A, ACTUALIZAR B --
WHERE A.COD_CLIENTE_SBS = B.COD_CLIENTE_SBS AND B.FLAG = 1;

--desde aqui ya empiezo a calcular la dim_cliente si el codigo_sbs vino en el periodo actual
--PASO 2 TEMPORAL PARA IDENTIFICAR COD_PERIODO_ULT
------------------------------------------------------
@@@

DROP TABLE TP_DIM_CLI_COD_PER_ULT;

@@@

create table TP_DIM_CLI_COD_PER_ULT
(
  cod_cliente_sbs   NUMERIC(18,2) not null,
  maxperiodo    NUMERIC(18,2),
  minperiodo    NUMERIC(18,2)
);

@@@

INSERT INTO  TP_DIM_CLI_COD_PER_ULT
SELECT SBS_FACT_SALDO.COD_CLIENTE_SBS,MAX(SBS_FACT_SALDO.COD_PERIODO) AS MAXPERIODO, MIN(SBS_FACT_SALDO.COD_PERIODO) AS MINPERIODO
FROM SBS_FACT_SALDO A, ACTUALIZAR B 
JOIN sbs_ods_producto ON SBS_FACT_SALDO.cod_subproducto = sbs_ods_producto.cod_subproducto 
AND sbs_ods_producto.Flg_producto in ('LINEA','SALDO')
WHERE A.COD_CLIENTE_SBS
GROUP BY SBS_FACT_SALDO.COD_CLIENTE_SBS
ORDER BY SBS_FACT_SALDO.COD_CLIENTE_SBS;

@@@--para pasar a otra sentencia espacio entre cada 
-- PASO 3 TEMPORAL PARA IDENTIFICAR EL CAMPO CNT_CPPDDP_3M ;

DROP TABLE TP_DIM_CLI_CNT_CPP_3M;

@@@

create table TP_DIM_CLI_CNT_CPP_3M
(
  cod_cliente_sbs NUMERIC(18,2) not null,
  CNT_CPPDDP_3M numeric(20)
);

@@@

insert into TP_DIM_CLI_CNT_CPP_3M
select cod_cliente_sbs, sum(cantidad) as CNT_CPPDDP_3M 
from 
(    select cod_cliente_sbs,  
    case when (por_saldo_deuda_tip1+
               por_saldo_deuda_tip2+
               por_saldo_deuda_tip3+
               por_saldo_deuda_tip4)>0 THEN 1 ELSE NULL END cantidad
    from sbs_ods_cliente 
    WHERE COD_PERIODO >=@@p_num_3_meses@@ --para periodo en duro anterior 201511
) tmp_sal_deud_tip
group by cod_cliente_sbs
ORDER by cod_cliente_sbs; 

-- PASO 4 TEMPORAL PARA IDENTIFICAR EL CAMPO CNT_DDP_24M 
@@@

DROP TABLE TP_DIM_CLI_CNT_DDP_24M;

@@@

create table TP_DIM_CLI_CNT_DDP_24M
(
  cod_cliente_sbs NUMERIC(18,2) not null,
  CNT_DDP_24M numeric(20)
);

@@@

insert into TP_DIM_CLI_CNT_DDP_24M
select cod_cliente_sbs, sum(cantidad) as CNT_DDP_24M 
from 
(    select cod_cliente_sbs,  
    case when (por_saldo_deuda_tip2+
               por_saldo_deuda_tip3+
               por_saldo_deuda_tip4)>0 THEN 1 ELSE NULL END cantidad
    from sbs_ods_cliente 
    WHERE COD_PERIODO >= @@p_num_24_meses@@ --201401 ---
) tmp_sal_deud_tip
group by cod_cliente_sbs
ORDER by cod_cliente_sbs;

@@@ 

-- PASO 5 TEMPORAL PARA IDENTIFICAR EL CAMPO CNT_NORMAL_12M 
DROP TABLE TP_DIM_CLI_CNT_NOR_12M;

@@@

create table TP_DIM_CLI_CNT_NOR_12M
(
  cod_cliente_sbs NUMERIC(18,2) not null,
  CNT_NOR_12M numeric(20)
);

@@@

insert into TP_DIM_CLI_CNT_NOR_12M
select cod_cliente_sbs, sum(cantidad) as CNT_NOR_12M 
from 
(    select cod_cliente_sbs,  
    case when por_saldo_deuda_tip0=100
         THEN 1 ELSE NULL END cantidad
    from sbs_ods_cliente 
    WHERE COD_PERIODO >= @@p_num_12_meses@@ --201501
) tmp_sal_deud_tip
group by cod_cliente_sbs
ORDER by cod_cliente_sbs;

@@@ 

--PASO 6 TEMPORAL PARA IDENTIFICAR FLG_GARANTIA
------------------------------------------------------
DROP TABLE TP_DIM_CLI_FLG_GAR;

@@@

create table TP_DIM_CLI_FLG_GAR
(
  cod_cliente_sbs   NUMERIC(18,2) not null,
  maxperiodo    NUMERIC(18,2)
);

@@@

INSERT INTO  TP_DIM_CLI_FLG_GAR
SELECT SBS_FACT_SALDO.COD_CLIENTE_SBS,MAX(SBS_FACT_SALDO.COD_PERIODO) AS MAXPERIODO
FROM SBS_FACT_SALDO 
JOIN sbs_ods_producto ON SBS_FACT_SALDO.cod_subproducto = sbs_ods_producto.cod_subproducto 
AND sbs_ods_producto.Flg_producto = 'GARANTIA' 
GROUP BY SBS_FACT_SALDO.COD_CLIENTE_SBS
ORDER BY SBS_FACT_SALDO.COD_CLIENTE_SBS;

@@@
--PASO 7 TEMPORAL PARA IDENTIFICAR FLG_SALDO_PMM_24M
------------------------------------------------------

DROP TABLE TP_DIM_CLI_FLG_SAL_PMM_24M;

@@@

create table TP_DIM_CLI_FLG_SAL_PMM_24M
(
  cod_cliente_sbs   NUMERIC(18,2) not null,
  CNT_FLG_SAL_PMM_24M numeric(20)  
);

@@@

INSERT INTO  TP_DIM_CLI_FLG_SAL_PMM_24M
SELECT COD_CLIENTE_SBS, SUM(CANTIDAD) AS FLG_SALDO_PMM_24M 
FROM
(
    SELECT SBS_FACT_SALDO.COD_CLIENTE_SBS,1 AS CANTIDAD
    FROM SBS_FACT_SALDO 
    JOIN sbs_ods_producto ON SBS_FACT_SALDO.cod_subproducto = sbs_ods_producto.cod_subproducto 
    AND sbs_ods_producto.Flg_producto IN( 'MED','PEQ','MICRO') and  DES_TIPPRODUCTO='SALDO'
    WHERE COD_PERIODO >= @@p_num_24_meses@@ --201401 --- meses anteriores
    GROUP BY SBS_FACT_SALDO.COD_CLIENTE_SBS
) TMP_FLG_GAR
GROUP BY COD_CLIENTE_SBS
ORDER BY COD_CLIENTE_SBS;

@@@
--PASO 8 TEMPORAL PARA IDENTIFICAR MTO_SALDO_PP_MAX_24M

DROP TABLE TP_DIM_CLI_MTO_SAL_PP_MAX_24M;

@@@

create table TP_DIM_CLI_MTO_SAL_PP_MAX_24M
(
  cod_cliente_sbs NUMERIC(18,2) not null,
  saldo         NUMERIC(18,2)
 );

@@@

 INSERT INTO TP_DIM_CLI_MTO_SAL_PP_MAX_24M
 SELECT SBS_FACT_SALDO.COD_CLIENTE_SBS, MAX(SBS_FACT_SALDO.MTO_SALDO) AS MTO_SALDO
 FROM SBS_FACT_SALDO
 JOIN sbs_ods_producto ON SBS_FACT_SALDO.cod_subproducto = sbs_ods_producto.cod_subproducto 
 AND sbs_ods_producto.Flg_producto ='PRESTAMO' and  DES_TIPPRODUCTO='SALDO'
 WHERE SBS_FACT_SALDO.COD_PERIODO >=@@p_num_24_meses@@-- 201401
 GROUP BY SBS_FACT_SALDO.COD_CLIENTE_SBS
 ORDER BY SBS_FACT_SALDO.COD_CLIENTE_SBS;

@@@ 
 --PASO 9 TEMPORAL PARA IDENTIFICAR MTO_LINEATC_MAX_24M  

DROP TABLE TP_DIM_CLI_MTO_LIN_TC_MAX_24M;

@@@

create table TP_DIM_CLI_MTO_LIN_TC_MAX_24M
(
  cod_cliente_sbs NUMERIC(18,2) not null,
  saldo         NUMERIC(18,2)
 );

@@@

 INSERT INTO TP_DIM_CLI_MTO_LIN_TC_MAX_24M
 SELECT SBS_FACT_SALDO.COD_CLIENTE_SBS, MAX(SBS_FACT_SALDO.MTO_SALDO) AS MTO_SALDO
 FROM SBS_FACT_SALDO
 JOIN sbs_ods_producto ON SBS_FACT_SALDO.cod_subproducto = sbs_ods_producto.cod_subproducto 
 AND sbs_ods_producto.Flg_producto ='TC' and  DES_TIPPRODUCTO='LINEA'
 WHERE SBS_FACT_SALDO.COD_PERIODO >= @@p_num_24_meses@@ --201401 ----@@p_num_24_meses@@
 GROUP BY SBS_FACT_SALDO.COD_CLIENTE_SBS
 ORDER BY SBS_FACT_SALDO.COD_CLIENTE_SBS;

@@@ 
 --PASO 10 TEMPORAL PARA IDENTIFICAR MTO_SALDO_PMM_MAX_24M   

DROP TABLE TP_DIM_CLI_MTO_SAL_PMM_MAX_24M;
create table TP_DIM_CLI_MTO_SAL_PMM_MAX_24M
(
  cod_cliente_sbs NUMERIC(18,2) not null,
  saldo         NUMERIC(18,2)
 );

@@@

 INSERT INTO TP_DIM_CLI_MTO_SAL_PMM_MAX_24M
 SELECT SBS_FACT_SALDO.COD_CLIENTE_SBS, MAX(SBS_FACT_SALDO.MTO_SALDO) AS MTO_SALDO
 FROM SBS_FACT_SALDO
 JOIN sbs_ods_producto ON SBS_FACT_SALDO.cod_subproducto = sbs_ods_producto.cod_subproducto 
 AND sbs_ods_producto.Flg_producto IN( 'MED','PEQ','MICRO') and  DES_TIPPRODUCTO='SALDO'
 WHERE SBS_FACT_SALDO.COD_PERIODO >= @@p_num_24_meses@@ --201401
 GROUP BY SBS_FACT_SALDO.COD_CLIENTE_SBS
 ORDER BY SBS_FACT_SALDO.COD_CLIENTE_SBS;
 
@@@

 --PASO 11 TEMPORAL PARA IDENTIFICAR EL CAMPO COD_PERIODO_SALDO_PP_MAX_24M
 --DEPENDE DE EL TEMPORAL (8) TP_DIM_CLI_MTO_SAL_PP_MAX_24M
 DROP TABLE TP_DIM_CLI_COD_PER_SAL_PP_MAX_24M;

@@@

create table TP_DIM_CLI_COD_PER_SAL_PP_MAX_24M
(
  cod_cliente_sbs NUMERIC(18,2) not null,
  PERIODO         NUMERIC(18,2)
 );

@@@
 
 INSERT INTO TP_DIM_CLI_COD_PER_SAL_PP_MAX_24M 
 SELECT SBS_FACT_SALDO.COD_CLIENTE_SBS,SBS_FACT_SALDO.COD_PERIODO FROM SBS_FACT_SALDO
 JOIN sbs_ods_producto ON SBS_FACT_SALDO.cod_subproducto = sbs_ods_producto.cod_subproducto 
 AND sbs_ods_producto.Flg_producto ='PRESTAMO' and  DES_TIPPRODUCTO='SALDO'
 JOIN TP_DIM_CLI_MTO_SAL_PP_MAX_24M ON SBS_FACT_SALDO.COD_CLIENTE_SBS||'-'||SBS_FACT_SALDO.MTO_SALDO = TP_DIM_CLI_MTO_SAL_PP_MAX_24M.COD_CLIENTE_SBS||'-'||TP_DIM_CLI_MTO_SAL_PP_MAX_24M.SALDO
ORDER BY SBS_FACT_SALDO.COD_CLIENTE_SBS;

@@@

--PASO 12 TEMPORAL PARA IDENTIFICAR EL CAMPO COD_PERIODO_LINEATC_MAX_24M 
 --DEPENDE DE EL TEMPORAL (9) TP_DIM_CLI_MTO_LIN_TC_MAX_24M
DROP TABLE TP_DIM_CLI_COD_PER_LIN_TC_MAX_24M;

@@@

create table TP_DIM_CLI_COD_PER_LIN_TC_MAX_24M
(
  cod_cliente_sbs NUMERIC(18,2) not null,
  PERIODO         NUMERIC(18,2)
 );

@@@
 
 INSERT INTO TP_DIM_CLI_COD_PER_LIN_TC_MAX_24M 
 SELECT SBS_FACT_SALDO.COD_CLIENTE_SBS,SBS_FACT_SALDO.COD_PERIODO FROM SBS_FACT_SALDO
 JOIN sbs_ods_producto ON SBS_FACT_SALDO.cod_subproducto = sbs_ods_producto.cod_subproducto 
 AND sbs_ods_producto.Flg_producto ='TC' and  DES_TIPPRODUCTO='LINEA'
 JOIN TP_DIM_CLI_MTO_LIN_TC_MAX_24M ON SBS_FACT_SALDO.COD_CLIENTE_SBS||'-'||SBS_FACT_SALDO.MTO_SALDO = TP_DIM_CLI_MTO_LIN_TC_MAX_24M.COD_CLIENTE_SBS||'-'||TP_DIM_CLI_MTO_LIN_TC_MAX_24M.SALDO
ORDER BY SBS_FACT_SALDO.COD_CLIENTE_SBS;

@@@
--PASO 13 TEMPORAL PARA IDENTIFICAR EL CAMPO COD_PERIODO_PMM_MAX_24M  
 --DEPENDE DE EL TEMPORAL (10) TP_DIM_CLI_MTO_SAL_PMM_MAX_24M

 DROP TABLE TP_DIM_CLI_COD_PER_SAL_PMM_MAX_24M;

@@@

create table TP_DIM_CLI_COD_PER_SAL_PMM_MAX_24M
(
  cod_cliente_sbs NUMERIC(18,2) not null,
  PERIODO         NUMERIC(18,2)
 );

@@@
 
 INSERT INTO TP_DIM_CLI_COD_PER_SAL_PMM_MAX_24M 
 SELECT SBS_FACT_SALDO.COD_CLIENTE_SBS,SBS_FACT_SALDO.COD_PERIODO FROM SBS_FACT_SALDO
 JOIN sbs_ods_producto ON SBS_FACT_SALDO.cod_subproducto = sbs_ods_producto.cod_subproducto 
 AND sbs_ods_producto.Flg_producto ='TC' and  DES_TIPPRODUCTO='LINEA'
 JOIN TP_DIM_CLI_MTO_SAL_PMM_MAX_24M ON SBS_FACT_SALDO.COD_CLIENTE_SBS||'-'||SBS_FACT_SALDO.MTO_SALDO = TP_DIM_CLI_MTO_SAL_PMM_MAX_24M.COD_CLIENTE_SBS||'-'||TP_DIM_CLI_MTO_SAL_PMM_MAX_24M.SALDO
ORDER BY SBS_FACT_SALDO.COD_CLIENTE_SBS;

/*--***********************
--datos para realizar prueba no aplica al modelo
select * from sbs_dim_cliente
 INSERT DE PRUEBAS SOBRE SBS_FACT_SALDO
 SELECT * FROM SBS_FACT_SALDO WHERE COD_CLIENTE_SBS = 4448
 INSERT INTO SBS_FACT_SALDO VALUES(

 4448,
 1,
 12,
 71230200000000,
 7186,
100,
 4,
 4,
 'CTSTGST',
 201511,
 191100);
--*********************************+ */
@@@

CREATE TABLE TP_CLI_RCC_MES AS 
SELECT min(a.cod_periodo) AS COD_PERIODO_BANCARIZACION,
       a.cod_entidad AS COD_ENTIDAD_BANCARIZACION, 
       b.cod_producto AS COD_PRODUCTO_BANCARIZACION,
       a.COD_CLIENTE_SBS, 
FROM SBS_FACT_SALDO a LEFT outer JOIN SBS_ODS_PRODUCTO b
ON  a.COD_SUBPRODUCTO = b.COD_SUBPRODUCTO
GROUP BY , COD_CLIENTE_SBS;
 
--PASO final con datos de cliente en el periodo actual SE DEBEN UTILZAR COMO FUENTES LAS TABLAS FACT CLIENTE 
--Y SALDO
--IDENTIFICAR CUALES SON LOS QUE NO HAN VENIDO
@@@

INSERT INTO TP_SBS_DIM_CLIENTE  --SE LLENA LA TABLA TEMPORAL, PARA 
SELECT
    F_CLIENTE.COD_CLIENTE_SBS,
    F_CLIENTE.TIP_DOCUMENTO_PRIN, 
    F_CLIENTE.COD_DOCUMENTO_PRIN,
    NULL, --COD_CLIENTE_PROP,
    CLIENTE.TIP_DOCUMENTO_TRIB, --TIP_DOCUMENTO_JUR
    CLIENTE.COD_RUC, --COD_DOCUMENTO_JUR
    CLIENTE.TIP_DOCUMENTO_IDENT, --TIP_DOCUMENTO_NAT
    CLIENTE.COD_DNI, --COD_DOCUMENTO_NAT
    CLIENTE.TIP_PERSONA, --TIP_PERSONA
    CLIENTE.NOM_PRIMER_NOMBRE, --NOM_PRIMER_NOMBRE
    CLIENTE.NOM_SEGUNDO_NOMBRE, --NOM_SEGUNDO_NOMBRE
    CLIENTE.NOM_RAZON_SOCIAL,-- NOM_APE_PATERNO
    CLIENTE.NOM_APE_MATERNO, --NOM_APE_MATERNO
    TP_DIM_CLI_COD_PER_ULT.MAXPERIODO, --COD_PERIODO_ULT
    F_CLIENTE.TIP_CLASIFICACION, --TIP CLASIFICIACION_ULTMES
    TP_CLI_RCC_MES.COD_PERIODO_BANCARIZACION,--COD_PERIODO_BANCARIZACION TOMAR DE LA TABLE TEMPORAL TP_CLI_RCC_MES 
    TP_CLI_RCC_MES.COD_PRODUCTO_BANCARIZACION,--COD_PRODUCTO_BANCARIZACION TOMAR DE LA TABLA TEMPORAL TP_CLI_RCC_MES
    TP_CLI_RCC_MES.COD_ENTIDAD_BANCARIZACION,--COD_ENTIDAD_BANCARIZACION TOMAR DE LA TABLA TEMPORTAL TP_CLI_RCC_MES
    F_CLIENTE.TIP_SIT_BANCARIZACION, -- TIP_SITUACION_BANCARIZACION
    CASE WHEN TP_DIM_CLI_CNT_CPP_3M.CNT_CPPDDP_3M =3 THEN 1 ELSE NULL END, --CNT_CPPDDP_3M
    CASE WHEN TP_DIM_CLI_CNT_DDP_24M.CNT_DDP_24M = 24 THEN 1 ELSE NULL END, --CNT_DDP_24M
    CASE WHEN TP_DIM_CLI_CNT_NOR_12M.CNT_NOR_12M = 12 THEN 1 ELSE NULL END, -- CNT_NOR_12M
    CASE WHEN TP_DIM_CLI_FLG_GAR.MAXPERIODO = @@p_num_11_meses@@ THEN 1 ELSE NULL END, --FLG_GARANTIA- 201601
    CASE WHEN TP_DIM_CLI_FLG_SAL_PMM_24M.CNT_FLG_SAL_PMM_24M =24 THEN 1 ELSE NULL END, --FLG_SALDO_PMM_24M 
    TP_DIM_CLI_MTO_SAL_PP_MAX_24M.SALDO , --MTO_SALDO_PP_MAX_24M 
    TP_DIM_CLI_MTO_LIN_TC_MAX_24M.SALDO, --MTO_LINEATC_MAX_24M 
    TP_DIM_CLI_MTO_SAL_PMM_MAX_24M.SALDO, --MTO_SALDO_PMM_MAX_24M 
    TP_DIM_CLI_COD_PER_SAL_PP_MAX_24M.PERIODO, --COD_PERIODO_SALDO_PP_MAX_24M 
    TP_DIM_CLI_COD_PER_LIN_TC_MAX_24M.PERIODO, --COD_PERIODO_LINEATC_MAX_24M 
    TP_DIM_CLI_COD_PER_SAL_PMM_MAX_24M.PERIODO, --COD_PERIODO_PMM_MAX_24M
    F_CLIENTE.COD_UBIGEO, --COD_UBIGEO
    F_CLIENTE.COD_SEGMENTO_PROP, --COD_SEGMENTO
    F_CLIENTE.MTO_INGRESO, --MTO_INGRESO
    F_CLIENTE.MTO_CUOTA_MES, --MTO_CUOTA_MES
    F_CLIENTE.TIP_MUNDO_PMM, --TIP_MUNDO_PMM 
    F_CLIENTE.TIP_MUNDO_CONSUMO , --TIP_MUNDO_CONSUMO 
    F_CLIENTE.TIP_MUNDO_HIP , --TIP_MUNDO_HIP 
    F_CLIENTE.TIP_MUNDO_EMP  --TIP_MUNDO_EMP 
 FROM sbs_fact_cliente F_CLIENTE
 LEFT JOIN SBS_ODS_CLIENTE CLIENTE ON F_CLIENTE.COD_CLIENTE_SBS = CLIENTE.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_COD_PER_ULT ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_COD_PER_ULT.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_CNT_CPP_3M ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_CNT_CPP_3M.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_CNT_DDP_24M ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_CNT_DDP_24M.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_CNT_NOR_12M ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_CNT_NOR_12M.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_FLG_GAR ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_FLG_GAR.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_FLG_SAL_PMM_24M ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_FLG_SAL_PMM_24M.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_MTO_SAL_PP_MAX_24M ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_MTO_SAL_PP_MAX_24M.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_MTO_LIN_TC_MAX_24M ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_MTO_LIN_TC_MAX_24M.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_MTO_SAL_PMM_MAX_24M ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_MTO_SAL_PMM_MAX_24M.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_COD_PER_SAL_PP_MAX_24M ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_COD_PER_SAL_PP_MAX_24M.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_COD_PER_LIN_TC_MAX_24M ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_COD_PER_LIN_TC_MAX_24M.COD_CLIENTE_SBS
 LEFT JOIN TP_DIM_CLI_COD_PER_SAL_PMM_MAX_24M ON F_CLIENTE.COD_CLIENTE_SBS = TP_DIM_CLI_COD_PER_SAL_PMM_MAX_24M.COD_CLIENTE_SBS
 LEFT JOIN TP_CLI_RCC_MES ON F_CLIENTE.COD_CLIENTE_SBS = TP_CLI_RCC_MES.COD_CLIENTE_SBS 
-----
 AND F_CLIENTE.COD_PERIODO= @@p_num_11_meses@@ --201601
 AND CLIENTE.COD_PERIODO= @@p_num_11_meses@@ --201601
 
 