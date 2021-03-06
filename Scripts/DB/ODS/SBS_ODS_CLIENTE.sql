TRUNCATE SBS_ODS_CLIENTE;

@@@

INSERT INTO SBS_ODS_CLIENTE
SELECT
to_number(to_char(TO_DATE(fec_reporte, 'YYYYMMDD'),'yyyymm'),'999999') as COD_PERIODO,
COD_CLIENTE_SBS,
FEC_REPORTE,
TIP_DOCUMENTO_TRIB,
COD_RUC,
TIP_DOCUMENTO_IDENT,
COD_DNI,
TIP_PERSONA,
TIP_EMPRESA,
CNT_EMPRESA,
POR_SALDO_DEUDA_TIP0,
POR_SALDO_DEUDA_TIP1,
POR_SALDO_DEUDA_TIP2,
POR_SALDO_DEUDA_TIP3,
POR_SALDO_DEUDA_TIP4,
NOM_RAZON_SOCIAL,
NOM_APE_MATERNO,
NOM_APE_CASADA,
NOM_PRIMER_NOMBRE,
NOM_SEGUNDO_NOMBRE
FROM SBS_STG_CLIENTE;

