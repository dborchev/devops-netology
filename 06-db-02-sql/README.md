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

