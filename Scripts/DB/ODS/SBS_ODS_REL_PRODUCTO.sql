delete from sbs_ods_rel_producto where cod_periodo = @@p_cod_periodo@@;

@@@

insert into sbs_ods_rel_producto 
select
cod_cuenta,
cod_subproducto,
tip_credito,
@@p_cod_periodo@@ 
from sbs_ods_rel_producto;