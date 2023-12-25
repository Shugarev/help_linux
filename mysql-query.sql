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

-- order_fraudreport, поля для матчинга: order_id,fraud_type,created
INSERT INTO `test_base`.`order_fraudreport`
            (`id`,
             `order_id`,
             `date`,
             `reason`,
             `fraud_type`,
             `report_date`,
             `extra`,
             `created`)
VALUES      ('1',
             '80607287632181031',
             '2023-10-08',
             'fraudreport',
             '10',
             '2023-10-09',
'{\"rrn\":\"\",\"arn\":\"74351062091188763786402\",\"fraud_amount\":\"234.83\"}',
'2023-08-27 20:43:57');

INSERT INTO `test_base`.`order_fraudreport`
            (`id`,
             `order_id`,
             `date`,
             `reason`,
             `fraud_type`,
             `report_date`,
             `extra`,
             `created`)
VALUES      ('5',
             '79529497354838039',
             '0000-00-00',
             'fraudreport',
             '10',
             '2023-08-21',
'{\"fraud_amount\":\"230.00\",\"arn\":\"74351062091188763786402\",\"rrn\":\"\"}',
'2023-08-21 18:04:01'); 



-- operation_extra поля для матчинга: operation_id, processing_date, rapid_dispute_resolution
INSERT INTO `test_base`.`operation_extra`
            (`operation_id`,
             `json`,
             `arn`,
             `processing_date`,
             `rapid_dispute_resolution`)
VALUES      ('15',
'{\"comment\":\"\",\"rapid_dispute_resolution\":0,\"reason_code\":\"10.4\",\"settlement_currency\":\"USD\",\"processing_date\":\"2022-05-10\",\"operation_subtype\":null,\"rrn\":\"\",\"vrol_financial_id\":\"10.4-2131\",\"reference_number\":\"5181627955\",\"settlement_amount\":\"7.50\",\"date\":\"2022-05-10\",\"arn\":\"74351062091188763786402\"}'
             ,
'74351062091188763786402',
'2023-08-21',
'1'); 

-- Запросы для статистики ~/task/box-perl-classes/sql-query/sql-query-by_dispute_fraud_card_schema.sql

-- если мы хотим провести заказ изменить для этого заказа дату, например на 2023-12-20 и чтобы успешно создавались enroll
-- запоминаем последнее entry_id в данном случае 60 
-- запоминаем id последней операции в данном случае 10   и id ордера
-- и проводим заказ и списание.

-- для всех entry `entry_id` > '60' меняем дату создания.
UPDATE `test_base`.`entry` SET `entry_created` = '2023-12-20 00:00:01' WHERE (`entry_id` > '60');

-- меняем дату с заказа
UPDATE `test_base`.`order` SET `created` = '2023-12-20 00:00:01' WHERE (`id` = '82223356695974931');

--  меняем дату для всех операций, которе соответствуют заказу
UPDATE `test_base`.`operation` SET `created` = '2023-12-20 00:00:01' WHERE (`id` > '10');


-- для удаления последнего enroll перед проведение enroll посмотреть на последний id в таблице entry допустим 72
-- запускаем enroll

-- удаляем все entry которые создал enroll.
DELETE FROM `test_base`.`entry` WHERE (`entry_id` > '72');

-- удаляем сам enroll
DELETE FROM `test_base`.`enrollment` WHERE (`id` = '82244287988320826');


SELECT TABLE_ROWS,TABLE_NAME,AUTO_INCREMENT,TABLE_SCHEMA FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'test_base' AND ( TABLE_ROWS<>0 OR AUTO_INCREMENT>1)

UPDATE  migrator SET value = 0 WHERE name= 'is_locked';
UPDATE  migrator SET value = '0304' WHERE name= 'last_position';