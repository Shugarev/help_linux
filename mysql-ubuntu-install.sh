#!/bin/bash

# su box
# cd /home/box

# Установка percona на ubuntu 20
# https://docs.percona.com/percona-server/5.7/installation/apt_repo.html

sudo apt-get -y install gnupg2

wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
sudo apt-get -y update
sudo apt-get install percona-server-server-5.7

# При установке ввести пароль для mysql root r00t.
sudo service mysq status
sudo service mysq start

# Create user and databases
rm -f create.sql
tee -a create.sql <<EOF
-- Смена пароля для root в MySQL
-- mysql -uroot -p # ввести временный пароль
-- SET PASSWORD FOR 'root'@'localhost' = PASSWORD('asdQWE123!@#');

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'r00t';

--  Создание баз в MySQL
CREATE DATABASE box;
CREATE DATABASE test_base;

-- Создание пользователей в MySQL
CREATE USER 'box'@'%' IDENTIFIED BY 'cDKwJDHOQcLfg02-';
CREATE USER 'test'@'%' IDENTIFIED BY 'eFbWBk%yCgq_dk3_';

-- Назначение прав пользователей на базы данных в MySQL
GRANT ALL ON box.* TO 'box'@'%';  
GRANT ALL ON test_base.* TO 'test'@'%';


-- Создание таблицы мигратор в основной базе и установка ссылку на первую миграуию.
USE box;

DROP TABLE IF EXISTS `migrator`;
CREATE TABLE `migrator` (
  `name` varchar(16) NOT NULL,
  `value` varchar(5) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `migrator` (`name`, `value`) VALUES
  ('last_position', '0'),
  ('is_locked', '0');

FLUSH PRIVILEGES;
EOF


rm -f extra-mysql.conf
tee -a extra-mysql.conf <<EOF
slow_query_log=1
slow_query_log_file=/var/log/mysql/mysql-slow.log
long_query_time=3
innodb_buffer_pool_size=6G
innodb_file_per_table=1
optimizer_switch = block_nested_loop=off
sql_mode = NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
query_cache_type=1
query_cache_size = 10M 
query_cache_limit=256K
EOF

cat extra-mysql.conf | sudo tee -a /etc/mysql/percona-server.conf.d/mysqld.cnf
sudo mysql -uroot -pr00t < create.sql
 
# закомментировать строку /etc/mysql/mysql.conf.d/mysqld.cnf
# bind-address = 127.0.0.1

#sed -i -e 's/^bind-address = 127.0.0.1/#bind-address = 127.0.0.1/' /etc/mysql/percona-server.conf.d/mysqld.cnf

sudo service mysql restart
sudo service mysql status
