TRUNCATE sbs_stg_saldo;

@@@

COPY sbs_stg_saldo FROM 'D:\rcc\saldos_@@p_cod_periodo@@.csv' DELIMITER ',' CSV HEADER;