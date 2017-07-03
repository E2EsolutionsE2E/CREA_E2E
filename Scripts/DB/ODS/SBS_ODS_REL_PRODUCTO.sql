INSERT INTO SBS_ODS_REL_PRODUCTO_HIST (COD_CUENTA,COD_SUBPRODUCTO,TIP_CREDITO,COD_PERIODO)
SELECT * FROM sbs_ods_rel_producto WHERE cod_periodo <> 201601--@@p_cod_periodo@@
ON CONFLICT (COD_CUENTA,TIP_CREDITO,COD_PERIODO)DO NOTHING
;

---@@@

truncate sbs_ods_rel_producto;

insert into sbs_ods_rel_producto 
select
cod_cuenta,
cod_subproducto,
tip_credito,
201601--@@p_cod_periodo@@ 
from sbs_stg_rel_producto
;
