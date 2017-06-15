--PRUEBA DE CAMBIO --

TRUNCATE sbs_stg_cliente;

@@@

COPY sbs_stg_cliente FROM 'D:\rcc\clientes_@@p_cod_periodo@@.csv' DELIMITER ',' CSV HEADER;