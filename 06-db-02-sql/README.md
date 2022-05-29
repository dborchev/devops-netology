# Домашнее задание к занятию "6.2. SQL"

https://github.com/netology-code/virt-homeworks/blob/virt-11/06-db-02-sql/README.md

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

https://github.com/dborchev/devops-netology/blob/main/06-db-02-sql/docker-compose.yml

```yaml
version: "3.4"

services:
  db:
    image: postgres:12
    ports:
        - "5432:5432"
    volumes:
        - data:/var/lib/postgresql/data
        - backup:/backup
    environment:          # единственная обязательная переменная
        POSTGRES_PASSWORD: PakledStrong
  adminer:                # adminer, потому что я себе не враг :-)
    image: adminer
    depends_on:
        - db
    ports:
        - "8080:8080"
volumes:
  data: {}
  backup: {}
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
```sql
CREATE DATABASE test_db;
CREATE USER "test-admin-user" WITH encrypted password "Duracell";
```
- в БД test_db создайте таблицу orders и clients

| таблица  | поля    |
|----------|---|
| orders | id (serial primary key) ; наименование (string) ; цена (integer) |
|clients | id (serial primary key) ; фамилия (string) ; страна проживания (string, index) ; заказ (foreign key orders)|

```sql
CREATE TABLE orders (
    id serial primary key, 
    наименование varchar, 
    цена integer
);
CREATE TABLE clients (
    id serial primary key,
    "фамилия" varchar,
    "страна проживания" varchar,
    "заказ" integer,
    FOREIGN KEY (заказ) REFERENCES  orders(id)
);
CREATE INDEX country ON clients("страна проживания");
```

- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db

```sql
GRANT ALL ON DATABASE test_db TO "test-admin-user";
```

- создайте пользователя test-simple-user
```sql
CREATE USER "test-simple-user" WITH ENCRYPTED PASSWORD 'TisButAScratch';
```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

```sql
GRANT select, insert, update, delete ON orders, clients TO "test-simple-user";
```

Приведите:
- итоговый список БД после выполнения пунктов выше,

```sql
postgres=# \l
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
(4 rows)
```

- описание таблиц (describe)

```sql
postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=# \d orders
                                    Table "public.orders"
    Column    |       Type        | Collation | Nullable |              Default
--------------+-------------------+-----------+----------+------------------------------------
 id           | integer           |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying |           |          |
 цена         | integer           |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
test_db=# \d clients
                                       Table "public.clients"
      Column       |       Type        | Collation | Nullable |               Default
-------------------+-------------------+-----------+----------+-------------------------------------
 id                | integer           |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying |           |          |
 страна проживания | character varying |           |          |
 заказ             | integer           |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
SELECT grantee, table_name, privilege_type
  FROM information_schema.table_privileges
  WHERE NOT grantee in ('postgres', 'PUBLIC');
```

- список пользователей с правами над таблицами test_db

```sql
     grantee      | table_name | privilege_type
------------------+------------+----------------
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
 test-simple-user | orders     | DELETE
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | clients    | DELETE
(8 rows)
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

```sql
INSERT INTO orders ("наименование", "цена")
VALUES
  ('Шоколад', 10),
  ('Принтер', 3000),
  ('Книга', 500),
  ('Монитор', 7000),
  ('Гитара', 4000)
;

INSERT INTO clients ("фамилия", "страна проживания")
VALUES
   ('Иванов Иван Иванович', 'USA'),
   ('Петров Петр Петрович', 'Canada'),
   ('Иоганн Себастьян Бах', 'Japan'),
   ('Ронни Джеймс Дио', 'Russia'),
   ('Ritchie Blackmore', 'Russia')
;

```

Используя SQL синтаксис вычислите количество записей для каждой таблицы 

```sql
test_db=# SELECT COUNT(*) FROM clients;
 count 
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM orders;
 count 
-------
     5
(1 row)
```


## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

```sql
UPDATE clients
  SET "заказ"=(
     SELECT id
     FROM orders
     WHERE "наименование"='Книга'
  ) 
  WHERE "фамилия"='Иванов Иван Иванович'
;
UPDATE clients
  SET "заказ"=(
      SELECT id 
      FROM orders
      WHERE "наименование"='Монитор'
  )
  WHERE "фамилия"='Петров Петр Петрович'
;
UPDATE clients
  SET "заказ"=(
      SELECT id
      FROM orders
      WHERE "наименование"='Гитара'
 )
  WHERE "фамилия"='Иоганн Себастьян Бах'
;
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```sql
test_db=# SELECT * FROM clients WHERE "заказ" IS NOT null;
 id |       Фамилия        | Страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```sql
test_db=# EXPLAIN (ANALYZE TRUE, VERBOSE TRUE) SELECT * FROM clients WHERE "заказ" IS NOT null;
                                                 QUERY PLAN
------------------------------------------------------------------------------------------------------------
 Seq Scan on public.clients  (cost=0.00..18.10 rows=806 width=72) (actual time=0.016..0.018 rows=3 loops=1)
   Output: id, "фамилия", "страна проживания", "заказ"
   Filter: (clients."заказ" IS NOT NULL)
   Rows Removed by Filter: 2
 Planning Time: 0.066 ms
 Execution Time: 0.035 ms
(6 rows)
```
- команда выводит план исполнения запроса, включая тип сканирования (Seq Scan - последовательный)
- выводит оценочную "цену" исполнения (cost), измеряемую в обращениях к диску
- с опцией ANALYZE также собственно выполняет запрос и выводит реальное время исполнения и объём вывода
- в поле Output выводит колонки вывода
- описывает фильтр и число отфильтрованных строк
- в конце, дано время планирования и исполнения запроса


## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```bash
root@f35990159916:/# ls -lah /backup
total 8.0K
drwxr-xr-x 2 root root 4.0K May 29 13:23 .
drwxr-xr-x 1 root root 4.0K May 29 13:28 ..
root@f35990159916:/# pg_dumpall -U postgres >/backup/backup.sql
root@f35990159916:/# ls -lah /backup
total 16K
drwxr-xr-x 2 root root 4.0K May 29 15:12 .
drwxr-xr-x 1 root root 4.0K May 29 13:28 ..
-rw-r--r-- 1 root root 7.0K May 29 15:12 backup.sql
root@f35990159916:/# head /backup/backup.sql
--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
root@f35990159916:/# exit
exit
$ sudo docker compose ls
NAME                STATUS              CONFIG FILES
06-db-02-sql        running(2)          /home/vagrant/devops-netology/06-db-02-sql/docker-compose.yml
$ sudo docker compose down
[+] Running 0/1
 ⠙ Container 06-db-02-sql-adminer-1  Stopping                                                                                   0.2s
[+] Running 1/1miner-1 exited with code 0
 ⠿ Container 06-db-02-sql-adminer-1  Removed                                                                                    0.3s
 ⠋ Container 06-db-02-sql-db-1       Stopping                                                                                   0.0s
06-db-02-sql-db-1       | 2022-05-29 15:13:51.405 UTC [1] LOG:  received fast shutdown request
06-db-02-sql-db-1       | 2022-05-29 15:13:51.408 UTC [1] LOG:  aborting any active transactions
06-db-02-sql-db-1       | 2022-05-29 15:13:51.411 UTC [1] LOG:  background worker "logical replication launcher" (PID 31) exited with[+] Running 1/2
[+] Running 3/3-db-02-sql-adminer-1  Removed                                                                                    0.3s
 ⠿ Container 06-db-02-sql-adminer-1  Removed                                                                                    0.3s
 ⠿ Container 06-db-02-sql-db-1       Removed                                                                                    0.3s
 ⠿ Network 06-db-02-sql_default      Removed                                                                                    0.1s
[1]+  Done                    sudo docker compose up
$ sudo docker compose ls
NAME                STATUS              CONFIG FILES
$ sudo docker volume ls
DRIVER    VOLUME NAME
local     06-db-02-sql_backup
local     06-db-02-sql_data
$ sudo docker volume rm 06-db-02-sql_data
06-db-02-sql_data
$ sudo docker volume ls
DRIVER    VOLUME NAME
local     06-db-02-sql_backup
$ sudo docker compose up &
[1] 11441
$ sudo docker volume ls
DRIVER    VOLUME NAME
local     06-db-02-sql_backup
local     06-db-02-sql_data
sudo docker exec -ti 06-db-02-sql-db-1 bash
root@e955ab3b37fd:/# ls -lah /backup
total 16K
drwxr-xr-x 2 root root 4.0K May 29 15:12 .
drwxr-xr-x 1 root root 4.0K May 29 15:16 ..
-rw-r--r-- 1 root root 7.0K May 29 15:12 backup.sql
root@e955ab3b37fd:/# psql -U postgres -f /backup/backup.sql
SET
SET
SET
...
   // snip
...
COPY 5
COPY 5
 setval
--------
      5
(1 row)

 setval
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
GRANT
GRANT
GRANT
```
