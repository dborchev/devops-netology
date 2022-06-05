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
