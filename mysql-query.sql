-- https://learn.microsoft.com/ru-ru/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver16


-- https://learn.microsoft.com/ru-ru/sql/t-sql/functions/json-modify-transact-sql?view=sql-server-ver16
UPDATE terminal SET config = JSON_SET(config,"$.support_mit",true ) WHERE config LIKE '%support_mit%';

-- https://dev.mysql.com/doc/refman/5.7/en/json-attribute-functions.html
SELECT id, driver, JSON_EXTRACT(config,"$.support_mit") as support_mit FROM terminal;


INSERT INTO `exchange_rate` (`id`, `created`, `effective_date`, `from`, `to`, `rate`, `xrate`, `provider`) 
VALUES ('103', '2022-10-12 17:41:57', '2022-10-17', 'KGS', 'USD', '1.000000000', '1.000000000', 'currencylayer');

INSERT INTO `exchange_rate` (`id`, `created`, `effective_date`, `from`, `to`, `rate`, `xrate`, `provider`) 
VALUES ('101', '2022-10-12 17:41:57', '2022-10-17', 'USD', 'KGS', '1.000000000', '1.000000000', 'currencylayer');

INSERT INTO `exchange_rate` (`id`, `created`, `effective_date`, `from`, `to`, `rate`, `xrate`, `provider`) 
VALUES ('102', '2022-10-12 17:41:57', '2022-10-17', 'USD', 'USD', '1.000000000', '1.000000000', 'currencylayer');

INSERT INTO `exchange_rate` (`id`, `created`, `effective_date`, `from`, `to`, `rate`, `xrate`, `provider`) 
VALUES ('104', '2022-10-12 17:41:57', '2022-10-17', 'KGS', 'KGS', '1.000000000', '1.000000000', 'currencylayer');

UPDATE `exchange_rate` SET `id`='99', `effective_date`='2022-10-17'; WHERE `id`='3100';
UPDATE  terminal SET config = NULL, driver='boxplat',secure3d_driver='boxplat';

UPDATE operation SET created= DATE_SUB(created, INTERVAL 2 DAY) WHERE id > 70;

SELECT `COLUMN_NAME` FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_NAME`='summary_stat' AND `COLUMN_NAME` LIKE '%cashflow%';
SELECT operation_type,operation_status,operation_amount,cashflow_currency,order_card_type,merchant_id,project_id,terminal_id,bank_id, day FROM summary_stat;


mysqld --innodb-buffer-pool-size=9G --innodb-buffer-pool-instances=16
SELECT @@innodb_buffer_pool_size/1024/1024/1024;


mysql -uroot -h127.0.0.1 -P3306 -pesxErUHv0fotUN+ixTYHoDQix*U
SET global general_log = 1;
SET global log_output = 'table';

-- clean log table
truncate mysql.general_log;
select * from mysql.general_log;


-- set profiling https://dev.mysql.com/doc/refman/8.0/en/show-profile.html
mysql -ubox -h127.0.0.1 -P3306 -paZ%34sdfDFtr test_base
SET profiling = 1;
SELECT @@profiling;

source  /home/sergey/data/summary-report-slowly/request_w_opt.txt
SHOW PROFILES;
