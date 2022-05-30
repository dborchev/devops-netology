# Домашнее задание к занятию "6.3. MySQL"

https://github.com/netology-code/virt-homeworks/blob/virt-11/06-db-03-mysql/README.md

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
- https://github.com/dborchev/devops-netology/blob/main/06-db-03-mysql/docker-compose.yml

Изучите [бэкап БД](https://github.com/dborchev/devops-netology/blob/main/06-db-03-mysql/test_data/test_dump.sql) и 
восстановитесь из него. ✅

Перейдите в управляющую консоль `mysql` внутри контейнера. ✅

Используя команду `\h` получите список управляющих команд.

```sql
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'
```

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

```sql
mysql> \s
...
Server version:         8.0.29 MySQL Community Server - GPL
...
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

```sql
mysql> USE test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
```

**Приведите в ответе** количество записей с `price` > 300.

```sql
mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

В следующих заданиях мы будем продолжать работу с данным контейнером.
