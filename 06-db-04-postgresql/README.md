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
