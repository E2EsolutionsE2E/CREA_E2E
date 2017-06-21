drop table SBS_ODS_SALDO;
drop table SBS_ODS_CLIENTE;
drop table SBS_STG_CLIENTE;
drop table SBS_STG_SALDO;
drop table SBS_ODS_PRODUCTO;
drop table SBS_ODS_REL_PRODUCTO;
drop table SBS_DIM_CLIENTE;
drop table SBS_DIM_CUENTA;
drop table SBS_DIM_ENTIDAD;
drop table SBS_DIM_PRODUCTO;
drop table SBS_DIM_UBIGEO;
drop table SBS_FACT_CLIENTE;
drop table SBS_FACT_SALDO;
drop table SBS_FACT_CLIENTE_ENTIDAD_PROD;
drop table SBS_FACT_CLIENTE_ENTIDAD;

create table SBS_STG_CLIENTE
(
COD_CLIENTE_SBS NUMERIC(18,2),
FEC_REPORTE VARCHAR(100),
TIP_DOCUMENTO_TRIB VARCHAR(100),
COD_RUC VARCHAR(100),
TIP_DOCUMENTO_IDENT VARCHAR(100),
COD_DNI VARCHAR(100),
TIP_PERSONA VARCHAR(100),
TIP_EMPRESA VARCHAR(100),
CNT_EMPRESA NUMERIC(18,2),
POR_SALDO_DEUDA_TIP0  NUMERIC(10,4),
POR_SALDO_DEUDA_TIP1 NUMERIC(10,4),
POR_SALDO_DEUDA_TIP2 NUMERIC(10,4),
POR_SALDO_DEUDA_TIP3 NUMERIC(10,4),
POR_SALDO_DEUDA_TIP4 NUMERIC(10,4),
NOM_RAZON_SOCIAL VARCHAR(100),
NOM_APE_MATERNO VARCHAR(100),
NOM_APE_CASADA VARCHAR(100),
NOM_PRIMER_NOMBRE VARCHAR(100),
NOM_SEGUNDO_NOMBRE VARCHAR(100)
);



create table SBS_STG_SALDO
(
COD_CLIENTE_SBS NUMERIC(18,2),
COD_ENTIDAD VARCHAR(10),
TIP_CREDITO VARCHAR(100),
COD_CUENTA VARCHAR(100),
NUM_CONDICION_DIAS NUMERIC (18,2),
MTO_SALDO NUMERIC (18,2),
TIP_CLASIFICACION VARCHAR(100),
FEC_REPORTE VARCHAR(100)
);

create table SBS_ODS_CLIENTE
(
COD_PERIODO  NUMERIC(18,2),
COD_CLIENTE_SBS NUMERIC(18,2),
FEC_REPORTE VARCHAR(100),
TIP_DOCUMENTO_TRIB VARCHAR(100),
COD_RUC VARCHAR(100),
TIP_DOCUMENTO_IDENT VARCHAR(100),
COD_DNI VARCHAR(100),
TIP_PERSONA VARCHAR(100),
TIP_EMPRESA VARCHAR(100),
CNT_EMPRESA NUMERIC(18,2),
POR_SALDO_DEUDA_TIP0  NUMERIC(10,4),
POR_SALDO_DEUDA_TIP1 NUMERIC(10,4),
POR_SALDO_DEUDA_TIP2 NUMERIC(10,4),
POR_SALDO_DEUDA_TIP3 NUMERIC(10,4),
POR_SALDO_DEUDA_TIP4 NUMERIC(10,4),
NOM_RAZON_SOCIAL VARCHAR(100),
NOM_APE_MATERNO VARCHAR(100),
NOM_APE_CASADA VARCHAR(100),
NOM_PRIMER_NOMBRE VARCHAR(100),
NOM_SEGUNDO_NOMBRE VARCHAR(100)
);

CREATE UNIQUE INDEX IDX_ODS_CLIENTE_PK 
ON SBS_ODS_CLIENTE (COD_PERIODO, COD_CLIENTE_SBS);


create table SBS_ODS_SALDO
(
COD_PERIODO  NUMERIC(18,2),
COD_CLIENTE_SBS NUMERIC(18,2),
COD_ENTIDAD VARCHAR(10),
TIP_CREDITO VARCHAR(100),
COD_CUENTA VARCHAR(100),
NUM_CONDICION_DIAS NUMERIC (18,2),
MTO_SALDO NUMERIC (18,2),
TIP_CLASIFICACION VARCHAR(100),
FEC_REPORTE VARCHAR(100)
);

CREATE UNIQUE INDEX IDX_ODS_SALDO_PK 
ON SBS_ODS_SALDO (COD_PERIODO, COD_CLIENTE_SBS, COD_ENTIDAD, TIP_CREDITO, COD_CUENTA,NUM_CONDICION_DIAS);

CREATE TABLE SBS_ODS_PRODUCTO
( 
	COD_SUBPRODUCTO    varchar(10)  NOT NULL ,
	DES_SUBPRODUCTO    varchar(100)  NULL ,
	COD_PRODUCTO       varchar(10)  NULL ,
	DES_PRODUCTO       VARchar(100)  NULL ,
	COD_FAMPRODUCTO    varchar(10)  NULL ,
	DES_FAMPRODUCTO    VARchar(100)  NULL ,
	TIP_PRODUCTO       varchar(10)  NULL ,
	DES_TIPPRODUCTO    VARchar(100)  NULL ,
	FLG_PRODUCTO       varchar(10)  NULL 
);

CREATE UNIQUE INDEX IDX_ODS_PRODUCTO_PK
ON SBS_ODS_PRODUCTO  (COD_SUBPRODUCTO);

CREATE TABLE SBS_ODS_REL_PRODUCTO
( 
	COD_CUENTA         VARCHAR(100)  NOT NULL ,
	COD_SUBPRODUCTO       VARCHAR(10)  NOT NULL ,
	TIP_CREDITO        VARCHAR(100)  NOT NULL ,
	COD_PERIODO        NUMERIC(18,2)  NOT NULL 
)
;

CREATE TABLE SBS_DIM_CLIENTE
( 
	COD_CLIENTE_SBS    NUMERIC(18,2)  NOT NULL ,
	TIP_DOCUMENTO_PRIN VARCHAR(100)  NULL ,
	COD_DOCUMENTO_PRIN VARCHAR(100)  NULL ,
	COD_CLIENTE_PROP   NUMERIC(18,2)  NULL ,
	TIP_DOCUMENTO_JUR  VARCHAR(100)  NULL ,
	COD_DOCUMENTO_JUR  VARCHAR(100)  NULL ,
	TIP_DOCUMENTO_NAT  VARCHAR(100)  NULL ,
	COD_DOCUMENTO_NAT  VARCHAR(100)  NULL ,
	TIP_PERSONA        VARCHAR(100)  NULL ,
	COD_PERIODO_BANCARIZACION VARCHAR(100)  NULL ,
	COD_PRODUCTO_BANCARIZACION NUMERIC(18,2)  NULL ,
	COD_ENTIDAD_BANCARIZACION VARCHAR(100) NULL ,
	TIP_SITUACION_BANCARIZACION VARCHAR(100)  NULL ,
	COD_PERIODO_COSECHA_PROP VARCHAR(100)  NULL ,
	COD_PRODUCTO_COSECHA_PROP NUMERIC(18,2)  NULL ,
	COD_PERIODO_ULT_PROP VARCHAR(100)  NULL ,
	TIP_SITUACION_PROP VARCHAR(100)  NULL ,
	NOM_PRIMER_NOMBRE  VARCHAR(100)  NULL ,
	NOM_SEGUNDO_NOMBRE VARCHAR(100)  NULL ,
	NOM_APE_PATERNO    VARCHAR(100)  NULL ,
	NOM_APE_MATERNO    VARCHAR(100)  NULL ,
	CNT_CPPDDP_3M      NUMERIC(18,2)  NULL ,
	CNT_DDP_24M        NUMERIC(18,2)  NULL ,
	CNT_NORMAL_12M     NUMERIC(18,2)  NULL ,
	FLG_GARANTIA       VARCHAR(100)  NULL ,
	FLG_SALDO_PMM_24M  NUMERIC(18,2)  NULL ,
	MTO_SALDO_PP_MAX_24M NUMERIC(18,2)  NULL ,
	MTO_LINEATC_MAX_24M NUMERIC(18,2)  NULL ,
	MTO_SALDO_PMM_MAX_24M NUMERIC(18,2)  NULL ,
	COD_PERIODO_SALDO_PP_MAX_24M VARCHAR(100)  NULL ,
	COD_PERIODO_LINEATC_MAX_24M VARCHAR(100)  NULL ,
	COD_PERIODO_PMM_MAX_24M VARCHAR(100)  NULL ,
	COD_UBIGEO         VARCHAR(100)  NULL ,
	COD_SEGMENTO_PROP  VARCHAR(100)  NULL ,
	TIP_MUNDO_CONSUMO  VARCHAR(100)  NULL ,
	MTO_INGRESO_CLI    NUMERIC(18,2)  NULL ,
	MTO_CUOTA_MES      NUMERIC(18,2)  NULL ,
	COD_PERIODO_ULT    VARCHAR(100)  NULL ,
	TIP_CLASIFICACION_ULTMES char(18)  NULL ,
	TIP_MUNDO_PMM      VARCHAR(100)  NULL ,
	TIP_MUNDO_HIP      VARCHAR(100)  NULL
)
;

CREATE UNIQUE INDEX IDX_DIM_CLIENTE_PK 
ON SBS_DIM_CLIENTE (COD_CLIENTE_SBS);

CREATE TABLE SBS_DIM_CUENTA
( 
	COD_CUENTA         VARCHAR(100)  NOT NULL ,
	DES_CUENTA         VARCHAR(100)  NULL ,
	COD_NIVEL1         NUMERIC(18,2)  NULL ,
	DES_NIVEL1         VARCHAR(100)  NULL ,
	COD_NIVEL2         NUMERIC(18,2)  NULL ,
	DES_NIVEL2         char(18)  NULL ,
	COD_NIVEL3         NUMERIC(18,2)  NULL ,
	DES_NIVEL3         char(18)  NULL ,
	COD_NIVEL4         NUMERIC(18,2)  NULL ,
	DES_NIVEL4         char(18)  NULL ,
	COD_NIVEL5         NUMERIC(18,2)  NULL ,
	DES_NIVEL5         char(18)  NULL
)
;

CREATE UNIQUE INDEX IDX_DIM_CUENTA_PK 
ON SBS_DIM_CUENTA (COD_CUENTA);

CREATE TABLE SBS_DIM_ENTIDAD
( 
	COD_ENTIDAD        VARCHAR(10)  NOT NULL ,
	DES_ENTIDAD        VARCHAR(100)  NULL ,
	DES_ALIAS          VARCHAR(100)  NULL ,
	TIP_ENTIDAD        VARCHAR(100)  NULL ,
	TIP_ENTIDAD_PROP   VARCHAR(100)  NULL 
)
;

CREATE UNIQUE INDEX IDX_DIM_ENTIDAD_PK 
ON SBS_DIM_ENTIDAD (COD_ENTIDAD);

CREATE TABLE SBS_DIM_PRODUCTO
( 
	COD_PRODUCTO       VARCHAR(10)  NOT NULL ,
	DES_PRODUCTO       VARCHAR(100)  NULL ,
	COD_GRP_PRODUCTO   VARCHAR(100)  NULL 
)
;

CREATE UNIQUE INDEX IDX_DIM_PRODUCTO_PK 
ON SBS_DIM_PRODUCTO (COD_PRODUCTO);

CREATE TABLE SBS_DIM_UBIGEO
( 
	COD_UBIGEO            VARCHAR(100)  NOT NULL ,
	DES_PROVINCIA         VARCHAR(100)  NULL ,
	DES_DEPARTAMENTO      VARCHAR(100)  NULL ,
	DES_ZONA              VARCHAR(100)  NULL ,
	DES_REGION_PROP       VARCHAR(100)  NULL ,
	DES_DISTRITO          char(18)  NULL ,
	FLG_CIUDAD_PROP       char(18)  NULL ,
	DES_GRP_DISTRITO_PROP char(18)  NULL ,
	FLG_CAPITAL           char(18)  NULL 
)
;

CREATE UNIQUE INDEX IDX_DIM_UBIGEO_PK 
ON SBS_DIM_UBIGEO (COD_UBIGEO);

CREATE TABLE SBS_FACT_CLIENTE
( 
	COD_PERIODO        NUMERIC(18,2)  NOT NULL ,
	COD_CLIENTE_SBS    NUMERIC(18,2)  NOT NULL ,
	TIP_DOCUMENTO_PRIN VARCHAR(100)  NULL ,
	TIP_PERSONA        VARCHAR(100)  NULL ,
	POR_DEUDA_TIPO0    NUMERIC(10,4)  NULL ,
	POR_DEUDA_TIPO1    NUMERIC(10,4)  NULL ,
	POR_DEUDA_TIPO2    NUMERIC(10,4)  NULL ,
	POR_DEUDA_TIPO3    NUMERIC(10,4)  NULL ,
	POR_DEUDA_TIPO4    NUMERIC(10,4)  NULL ,
	TIP_CLASIFICACION  CHAR(2)  NULL ,
	TIP_SIT_BANCARIZACION VARCHAR(100)  NULL ,
	TIP_ENTIDAD_PROP_MAX VARCHAR(100)  NULL ,
	CNT_ENTIDAD        NUMERIC(18,2)  NULL ,
	CNT_ENTIDAD_SALDOTC NUMERIC(18,2)  NULL ,
	CNT_ENTIDAD_LINEATC NUMERIC(18,2)  NULL ,
	CNT_ENTIDAD_PP     NUMERIC(18,2)  NULL ,
	CNT_ENTIDAD_PMM    NUMERIC(18,2)  NULL ,
	CNT_ENTIDAD_LINEA_PMM NUMERIC(18,2)  NULL ,
	CNT_ENTIDAD_HIP    NUMERIC(18,2)  NULL ,
	MTO_SALDO          NUMERIC(18,2)  NULL ,
	MTO_SALDO_INDIRECTO NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO  NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_TC NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_LD NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_VEH NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_TC_DEF NUMERIC(18,2)  NULL ,
	MTO_SALDO_LINEATC  NUMERIC(18,2)  NULL ,
	MTO_SALDO_MED      NUMERIC(18,2)  NULL ,
	MTO_SALDO_PEQ      NUMERIC(18,2)  NULL ,
	MTO_SALDO_MICRO    NUMERIC(18,2)  NULL ,
	MTO_SALDO_LINEA_PMM NUMERIC(18,2)  NULL ,
	MTO_SALDO_HIP      NUMERIC(18,2)  NULL ,
	MTO_SALDO_HIP_MIV  NUMERIC(18,2)  NULL ,
	MTO_SALDO_EMP      NUMERIC(18,2)  NULL ,
	MTO_SALDO_LINEA_EMP NUMERIC(18,2)  NULL ,
	MTO_SALDO_REFINANCIADO NUMERIC(18,2)  NULL ,
	MTO_SALDO_CASTIGO  NUMERIC(18,2)  NULL ,
	MTO_SALDO_JUDICIAL NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_PROP NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_TC_PROP NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_LD_PROP NUMERIC(18,2)  NULL ,
	MTO_SALDO_PMM_PROP NUMERIC(18,2)  NULL ,
	MTO_SALDO_LINEA_PMM_PROP NUMERIC(18,2)  NULL ,
	MTO_SALDO_LINA_TC_PROP NUMERIC(18,2)  NULL ,
	MTO_SALDO_REFINANCIADO_PROP NUMERIC(18,2)  NULL ,
	MTO_SALDO_CASTIGO_PROP NUMERIC(18,2)  NULL ,
	MTO_SALDO_JUDICIAL_PROP NUMERIC(18,2)  NULL ,
	COD_ENTIDAD_PRINC  VARCHAR(10)  NULL ,
	COD_ENTIDAD_PRINC_LINEA_TC VARCHAR(10)  NULL ,
	COD_ENTIDAD_PRINC_SALDO_TC VARCHAR(10)  NULL ,
	COD_ENTIDAD_PRINC_PP VARCHAR(10)  NULL ,
	COD_ENTIDAD_PRINC_PMM VARCHAR(10)  NULL ,
	COD_ENTIDAD_PRINC_LINEA_PMM VARCHAR(10)  NULL ,
	COD_ENTIDAD_PRINC_HIP VARCHAR(10)  NULL ,
	COD_ENTIDAD_PRINC_TC_DEF VARCHAR(10)  NULL ,
	
	MTO_CUOTA_MES      NUMERIC(18,2)  NULL ,
	MTO_INGRESO        NUMERIC(18,2)  NULL ,
	COD_SEGMENTO_PROP  NUMERIC(18,2)  NULL ,
	TIP_MUNDO_PMM      VARCHAR(100)  NULL ,
	COD_DOCUMENTO_PRIN VARCHAR(100)  NULL ,
	MTO_SALDO_CONSUMO_VEH_PROP NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_TC_DEF_PROP NUMERIC(18,2)  NULL ,
	TIP_MUNDO_CONSUMO  VARCHAR(100)  NULL ,
	TIP_MUNDO_HIP      VARCHAR(100)  NULL ,
	TIP_MUNDO_EMP      VARCHAR(100)  NULL ,
	COD_UBIGEO         VARCHAR(100)  NULL 
)
;

CREATE UNIQUE INDEX IDX_FACT_CLIENTE_PK 
ON SBS_FACT_CLIENTE (COD_PERIODO ,COD_CLIENTE_SBS);


CREATE TABLE SBS_FACT_CLIENTE_ENTIDAD
( 
	COD_PERIODO        NUMERIC(18,2)  NOT NULL ,
	COD_CLIENTE_SBS    NUMERIC(18,2)  NOT NULL ,
	COD_DOCUMENTO_PRIN VARCHAR(100)  NULL ,
	COD_ENTIDAD        VARCHAR(10)  NOT NULL ,
	TIP_CLASIFICACION  CHAR(2)  NULL ,
	COD_PERIODO_COSECHA NUMERIC(18,2)  NULL ,
	COD_SUBPRODUCTO_COSECHA VARCHAR(10)  NULL ,
	MTO_SALDO          NUMERIC(18,2)  NULL ,
	MTO_SALDO_INDIRECTO NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO  NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_TC NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_LD NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_VEH NUMERIC(18,2)  NULL ,
	MTO_SALDO_CONSUMO_TC_DEF NUMERIC(18,2)  NULL ,
	MTO_SALDO_LINEATC  NUMERIC(18,2)  NULL ,
	MTO_SALDO_MICRO    NUMERIC(18,2)  NULL ,
	MTO_SALDO_PEQ      NUMERIC(18,2)  NULL ,
	MTO_SALDO_MED      NUMERIC(18,2)  NULL ,
	MTO_SALDO_LINEA_PMM NUMERIC(18,2)  NULL ,
	MTO_SALDO_HIP      NUMERIC(18,2)  NULL ,
	MTO_SALDO_HIP_MIV  NUMERIC(18,2)  NULL ,
	MTO_SALDO_EMP      NUMERIC(18,2)  NULL ,
	MTO_SALDO_LINEAEMP NUMERIC(18,2)  NULL ,
	MTO_SALDO_REFINANCIADO NUMERIC(18,2)  NULL ,
	MTO_SALDO_CASTIGO  NUMERIC(18,2)  NULL ,
	MTO_SALDO_JUDICIAL NUMERIC(18,2)  NULL ,
	MTO_CUOTA_MES      NUMERIC(18,2)  NULL ,
	TIP_DOCUMENTO_PRIN VARCHAR(100)  NULL ,
	COD_UBIGEO         VARCHAR(100)  NULL 
)
;

CREATE UNIQUE INDEX IDX_FACT_CLIENTE_ENTIDAD_PK 
ON SBS_FACT_CLIENTE_ENTIDAD (COD_PERIODO ,COD_CLIENTE_SBS ,COD_ENTIDAD );

CREATE TABLE SBS_FACT_CLIENTE_ENTIDAD_PROD
( 
	COD_PERIODO        NUMERIC(18,2)  NOT NULL ,
	COD_CLIENTE_SBS    NUMERIC(18,2)  NOT NULL ,
	COD_DOCUMENTO_PRIN VARCHAR(100)  NULL ,
	COD_ENTIDAD        VARCHAR(10)  NOT NULL ,
	TIP_CLASIFICACION  CHAR(2)  NULL ,
	COD_SUBPRODUCTO       VARCHAR(10)  NOT NULL ,
	MTO_SALDO          NUMERIC(18,2)  NULL ,
	COD_PERIODO_COSECHA  NUMERIC(18,2)  NULL ,
	TIP_ESTADO_PRODUCTO VARCHAR(100)  NULL ,
	TIP_DOCUMENTO_PRIN VARCHAR(100)  NULL ,
	COD_UBIGEO         VARCHAR(100)  NULL 
)
;

CREATE UNIQUE INDEX IDX_FACT_CLIENTE_ENTIDAD_PROD_PK 
ON SBS_FACT_CLIENTE_ENTIDAD_PROD (COD_PERIODO ,COD_CLIENTE_SBS ,COD_ENTIDAD ,COD_SUBPRODUCTO );


CREATE TABLE SBS_FACT_SALDO
( 
	COD_CLIENTE_SBS    NUMERIC(18,2)  NOT NULL ,
	COD_ENTIDAD        VARCHAR(10)  NOT NULL ,
	TIP_CREDITO        VARCHAR(100)  NOT NULL ,
	COD_CUENTA         VARCHAR(100)  NOT NULL ,
	NUM_CONDICION_DIAS NUMERIC(18,2)  NULL ,
	MTO_SALDO          NUMERIC(18,2)  NULL ,
	TIP_CLASIFICACION  CHAR(2)  NULL ,
	COD_SITCREDITO	   CHAR(1) NULL,
	COD_SUBPRODUCTO       VARCHAR(10)  NOT NULL ,
	COD_PERIODO        NUMERIC(18,2)  NOT NULL ,
	COD_UBIGEO         VARCHAR(100)  NULL
)
;

CREATE UNIQUE INDEX IDX_FACT_SALDO_PK 
ON SBS_FACT_SALDO (COD_PERIODO ,COD_CLIENTE_SBS ,COD_CUENTA, NUM_CONDICION_DIAS,TIP_CREDITO ,COD_ENTIDAD ,COD_SUBPRODUCTO );