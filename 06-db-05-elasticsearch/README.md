# Домашнее задание к занятию "6.5. Elasticsearch"

https://github.com/netology-code/virt-homeworks/blob/virt-11/06-db-05-elasticsearch/README.md

## Задача 1

В ответе приведите:
- текст Dockerfile манифеста
  -  https://github.com/dborchev/devops-netology/blob/main/06-db-05-elasticsearch/Dockerfile
- ссылку на образ в репозитории dockerhub
  - https://hub.docker.com/repository/docker/askbow/netology-06-db-05-elasticsearch-task1
- ответ `elasticsearch` на запрос пути `/` в json виде

```json
$ sudo docker exec 4d211d46bac7 curl -Ss --cacert /usr/share/elasticsearch/co
nfig/certs/http_ca.crt -u elastic:PakleedStrong https://localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "O4zFs---TO2JKLNbXICPDQ",
  "version" : {
    "number" : "8.2.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "9876968ef3c745186b94fdabd4483e01499224ef",
    "build_date" : "2022-05-25T15:47:06.259735307Z",
    "build_snapshot" : false,
    "lucene_version" : "9.1.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

>Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

>Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```bash
$ sudo docker exec 4d211d46bac7 curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong https://localhost:9200/_cat/indices?v
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   ind-3 -RPj_BqDR8-4WvgkF6KAZQ   4   2          0            0       413b           413b
yellow open   ind-2 yHdpOMkBTnuLw3s3D5epbA   2   1          0            0       225b           225b
green  open   ind-1 wDnFz8aySq62fTDtglXvxw   1   0          0            0       225b           225b
```

>Получите состояние кластера `elasticsearch`, используя API.

```json
$ sudo docker exec 4d211d46bac7 curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong https://localhost:9200/_cluster/health?pretty
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 47.368421052631575
}
```

>Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Поскольку число шард у индексов ind-2 и ind-3 больше числа узлов в кластере, часть из них никуда не назначены.

>Удалите все индексы.

```bash
$ sudo docker exec 4d211d46bac7 curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong -X DELETE https://localhost:9200/ind-1?pretty
[2022-06-05T15:26:29,096][INFO ][o.e.c.m.MetadataDeleteIndexService] [netology_test] [ind-1/wDnFz8aySq62fTDtglXvxw] deleting index
{
  "acknowledged" : true
}
$ sudo docker exec 4d211d46bac7 curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong -X DELETE https://localhost:9200/ind-2?pretty
[2022-06-05T15:26:33,672][INFO ][o.e.c.m.MetadataDeleteIndexService] [netology_test] [ind-2/yHdpOMkBTnuLw3s3D5epbA] deleting index
{
  "acknowledged" : true
}
$ sudo docker exec 4d211d46bac7 curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong -X DELETE https://localhost:9200/ind-3?pretty
[2022-06-05T15:26:38,151][INFO ][o.e.c.m.MetadataDeleteIndexService] [netology_test] [ind-3/-RPj_BqDR8-4WvgkF6KAZQ] deleting index
{
  "acknowledged" : true
}
```

## Задача 3

>Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Небольшая модификация докерфайла: https://github.com/dborchev/devops-netology/commit/6f116aba45e08eb03a14182ae0c517cda0af7dc6

>Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
>данную директорию как `snapshot repository` c именем `netology_backup`.
>**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```bash
$ sudo docker exec funny_khorana curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong \
  -X PUT https://localhost:9200/_snapshot/netology_backup?pretty \
  -H 'Content-Type: application/json' \
  -d' { "type": "fs", "settings": { "location": "/usr/share/elasticsearch/snapshots"}}'
[2022-06-05T15:50:31,287][INFO ][o.e.r.RepositoriesService] [netology_test] put repository [netology_backup]
{
  "acknowledged" : true
}
```

>Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```bash
$ sudo docker exec funny_khorana curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong https://localhost:9200/_cat/indices?v
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  hoiZiu1KT7yoQssCZIhrCw   1   0          0            0       225b           225b
```

>[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
>состояния кластера `elasticsearch`.
>**Приведите в ответе** список файлов в директории со `snapshot`ами.

```bash
$ sudo docker exec funny_khorana ls -lah /usr/share/elasticsearch/snapshots
total 12K
drwxr-xr-x 1 elasticsearch elasticsearch 4.0K Jun  5 15:50 .
drwx------ 1 elasticsearch elasticsearch 4.0K Jun  5 15:50 ..
$ sudo docker exec funny_khorana curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong -X PUT "https://localhost:9200/_snapshot/netology_backup/snapshot?wait_for_completion=true"
[2022-06-05T15:59:03,656][INFO ][o.e.s.SnapshotsService   ] [netology_test] snapshot [netology_backup:snapshot/zTbT7ysFTwmBUu7AQxwFKw] started
{"snapshot":{"snapshot":"snapshot","uuid":"zTbT7ysFTwmBUu7AQxwFKw","repository":"netology_backup","version_id":8020299,"version":"8.2.2","indices":["test",".geoip_databases",".security-7"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-06-05T15:59:03.486Z","start_time_in_millis":1654444743486,"end_time":"2022-06-05T15:59:04.890Z","end_time_in_millis":1654444744890,"duration_in_millis":1404,"failures":[],"shards":{"total":3,"failed":0,"successful":3},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]},{"feature_name":"security","indices":[".security-7"]}]}}[2022-06-05T15:59:05,105][INFO ][o.e.s.SnapshotsService   ] [netology_test] snapshot [netology_backup:snapshot/zTbT7ysFTwmBUu7AQxwFKw] completed with state [SUCCESS]
$ sudo docker exec funny_khorana ls -lah /usr/share/elasticsearch/snapshots
total 48K
drwxr-xr-x 1 elasticsearch elasticsearch 4.0K Jun  5 15:59 .
drwx------ 1 elasticsearch elasticsearch 4.0K Jun  5 15:50 ..
-rw-r--r-- 1 elasticsearch elasticsearch 1.1K Jun  5 15:59 index-0
-rw-r--r-- 1 elasticsearch elasticsearch    8 Jun  5 15:59 index.latest
drwxr-xr-x 5 elasticsearch elasticsearch 4.0K Jun  5 15:59 indices
-rw-r--r-- 1 elasticsearch elasticsearch  18K Jun  5 15:59 meta-zTbT7ysFTwmBUu7AQxwFKw.dat
-rw-r--r-- 1 elasticsearch elasticsearch  382 Jun  5 15:59 snap-zTbT7ysFTwmBUu7AQxwFKw.dat
```

>Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```bash
$ sudo docker exec funny_khorana curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong https://localhost:9200/_cat/indices?v
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 dUuuc7JkRsy8QaWGYvQ_4Q   1   0          0            0       225b           225b
```

>[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
>кластера `elasticsearch` из `snapshot`, созданного ранее. 
>**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```bash
$ sudo docker exec funny_khorana curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong -X POST https://localhost:9200/_snapshot/netology_backup/snapshot/_restore?pretty
{
  "accepted" : true
}
[2022-06-05T16:04:41,258][INFO ][o.e.c.r.a.AllocationService] [netology_test] current.health="GREEN" message="Cluster health status changed from [YELLOW] to [GREEN] (reason: [shards started [[test][0]]])." previous.health="YELLOW" reason="shards started [[test][0]]"

$ sudo docker exec funny_khorana curl -Ss --cacert /usr/share/elasticsearch/config/certs/http_ca.crt -u elastic:PakleedStrong https://localhost:9200/_cat/indices?v
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test   YBVP8eXDRveIQ3vGWz0skw   1   0          0            0       225b           225b
green  open   test-2 dUuuc7JkRsy8QaWGYvQ_4Q   1   0          0            0       225b           225b
```
