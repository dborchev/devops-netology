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
