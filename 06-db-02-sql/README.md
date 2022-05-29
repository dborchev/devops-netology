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

