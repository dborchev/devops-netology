# Домашнее задание к занятию "6.4. PostgreSQL"

https://github.com/netology-code/virt-homeworks/blob/virt-11/06-db-04-postgresql/README.md

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
    + https://github.com/dborchev/devops-netology/blob/main/06-db-04-postgresql/docker-compose.yml

Подключитесь к БД PostgreSQL используя `psql`. ✅

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам. ✅

**Найдите и приведите** управляющие команды для:
- вывода списка БД
  - `\l`, `\l+` (здесь и далее, варианты с "+" дают больше информации)
- подключения к БД
  - `\c`
- вывода списка таблиц
  - `\dtS`, `\dtS+`
- вывода описания содержимого таблиц
  - `\dS`, `\dS+` с указанием инени, например:
  ```sql
  postgres=# \dS+ pg_aggregate
                                     Table "pg_catalog.pg_aggregate"
        Column      |   Type   | Collation | Nullable | Default | Storage  | Stats target | Description
  ------------------+----------+-----------+----------+---------+----------+--------------+-------------
   aggfnoid         | regproc  |           | not null |         | plain    |              |
   aggkind          | "char"   |           | not null |         | plain    |              |
   aggnumdirectargs | smallint |           | not null |         | plain    |              |
   aggtransfn       | regproc  |           | not null |         | plain    |              |
   aggfinalfn       | regproc  |           | not null |         | plain    |              |
   aggcombinefn     | regproc  |           | not null |         | plain    |              |
   aggserialfn      | regproc  |           | not null |         | plain    |              |
   aggdeserialfn    | regproc  |           | not null |         | plain    |              |
   aggmtransfn      | regproc  |           | not null |         | plain    |              |
   aggminvtransfn   | regproc  |           | not null |         | plain    |              |
   aggmfinalfn      | regproc  |           | not null |         | plain    |              |
   aggfinalextra    | boolean  |           | not null |         | plain    |              |
   aggmfinalextra   | boolean  |           | not null |         | plain    |              |
   aggfinalmodify   | "char"   |           | not null |         | plain    |              |
   aggmfinalmodify  | "char"   |           | not null |         | plain    |              |
   aggsortop        | oid      |           | not null |         | plain    |              |
   aggtranstype     | oid      |           | not null |         | plain    |              |
   aggtransspace    | integer  |           | not null |         | plain    |              |
   aggmtranstype    | oid      |           | not null |         | plain    |              |
   aggmtransspace   | integer  |           | not null |         | plain    |              |
   agginitval       | text     | C         |          |         | extended |              |
   aggminitval      | text     | C         |          |         | extended |              |
  Indexes:
      "pg_aggregate_fnoid_index" UNIQUE, btree (aggfnoid)
  Access method: heap
  ```
- выхода из psql
  - `\q`

## Задача 2

Используя `psql` создайте БД `test_database`.

```sql
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=#
```

Изучите [бэкап БД](https://github.com/dborchev/devops-netology/blob/main/06-db-04-postgresql/test_data). ✅

Восстановите бэкап БД в `test_database`.

```bash
vagrant@vagrant:~/devops-netology/06-db-04-postgresql$ ll test_data/
total 12
drwxrwxr-x 2 vagrant vagrant 4096 Jun  5 09:51 ./
drwxrwxr-x 3 vagrant vagrant 4096 Jun  5 09:53 ../
-rw-rw-r-- 1 vagrant vagrant 2082 Jun  5 09:51 test_dump.sql
vagrant@vagrant:~/devops-netology/06-db-04-postgresql$ sudo docker cp ./test_data/test_dump.sql 06-db-04-postgresql-db-1:/backup
vagrant@vagrant:~/devops-netology/06-db-04-postgresql$ sudo docker exec -it 06-db-04-postgresql-db-1 bash
root@7ff7ec0e64bc:/# ls /backup
test_dump.sql
root@7ff7ec0e64bc:/# psql -U postgres -f /backup/test_dump.sql test_database
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```

Перейдите в управляющую консоль `psql` внутри контейнера. ✅

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```sql
test_database=# \dtS+ orders
                              List of relations
 Schema |  Name  | Type  |  Owner   | Persistence |    Size    | Description
--------+--------+-------+----------+-------------+------------+-------------
 public | orders | table | postgres | permanent   | 8192 bytes |
(1 row)

test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

>"avg_width	integer	 	Средний размер элементов в столбце, в байтах"

```sql
test_database=# SELECT attname, avg_width FROM pg_stats
  WHERE tablename='orders'
  ORDER BY avg_width 
  DESC LIMIT 1
;
 attname | avg_width
---------+-----------
 title   |        16
(1 row)
``` 

## Задача 3

>Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

>Предложите SQL-транзакцию для проведения данной операции.

```sql
BEGIN;
CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
INSERT INTO orders_1
  SELECT * FROM orders
  WHERE price > 499
;
CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);
INSERT INTO orders_2
  SELECT * FROM orders
  WHERE price <= 499
;
DELETE FROM ONLY orders;
COMMIT;
```


```sql
test_database=# \dtS+ orders*
                              List of relations
 Schema |  Name  | Type  |  Owner   | Persistence |    Size    | Description
--------+--------+-------+----------+-------------+------------+-------------
 public | orders | table | postgres | permanent   | 8192 bytes |
(1 row)

test_database=# BEGIN;
CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
INSERT INTO orders_1
  SELECT * FROM orders
  WHERE price > 499
;
CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);
INSERT INTO orders_2
  SELECT * FROM orders
  WHERE price <= 499
;
DELETE FROM ONLY orders;
COMMIT;
BEGIN
CREATE TABLE
INSERT 0 3
CREATE TABLE
INSERT 0 5
DELETE 8
COMMIT
test_database=# \dtS+ orders*
                                    List of relations
 Schema |   Name   | Type  |  Owner   | Persistence |    Size    | Description
--------+----------+-------+----------+-------------+------------+-------------
 public | orders   | table | postgres | permanent   | 8192 bytes |
 public | orders_1 | table | postgres | permanent   | 8192 bytes |
 public | orders_2 | table | postgres | permanent   | 8192 bytes |
(3 rows)
```

>Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Можно, описав разделение изначально, например

```sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
) PARTITION BY RANGE (price);

CREATE TABLE orders_2 PARTITION OF orders
    FOR VALUES FROM (0) TO (499);

CREATE TABLE orders_2 PARTITION OF orders
    FOR VALUES FROM (500);
```

в https://www.postgresql.org/docs/current/ddl-partitioning.html способ разедления через INHERIT с описанием CHECK, процедур вставки, или созданием правил (CREATE RULE). Много способов под разные ситуации.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```bash
root@7ff7ec0e64bc:/# pg_dump -h localhost -U postgres test_database > /backup/test_database_backup.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

```sql
 CREATE TABLE public.orders (
     id integer NOT NULL,
     title character varying(80) NOT NULL UNIQUE,
     price integer DEFAULT 0
 );
```
+ https://github.com/dborchev/devops-netology/commit/1a0410ba614626f0568ad37f6428da31cb83a8f8

```sql
test_database=# \d public.orders
                                   Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 title  | character varying(80) |           | not null |
 price  | integer               |           |          | 0
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
    "orders_title_key" UNIQUE CONSTRAINT, btree (title)
```
