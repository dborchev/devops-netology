# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

https://github.com/netology-code/virt-homeworks/blob/virt-11/05-virt-05-docker-swarm/README.md

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
  - при развертывании реплицированного сервиса, мы указываем число копий сервиса (реплик), и кластер размещает их на рабочих узлах в заданном количестве. Если в кластере меньше узлов, чем целевое число реплик, на некоторых узлах може выполняться по несколько копий
  - при развертывании глобального сервиса, все узлы кластера (в пределах ограничений заданных в конфигурации сервиса, по-умолчанию -- просто все) получают по одной копии сервиса
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
  - Raft
- Что такое Overlay Network?
  - наложенная сеть -- сеть в которой топология и адресация не известны (или даже не зависят от) транспортной (подлежащей, underlay) сети. Раньше такие сети просто называли виртуальными, но сейчас другая мода.

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

```bash
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
swo33jlp0nsqbhvepvkdxou89 *   node01.netology.yc   Ready     Active         Leader           20.10.16
7ov5em5q30rk0vfm0929vnw0v     node02.netology.yc   Ready     Active         Reachable        20.10.16
l1x1479v3j9bykhgas6ucl661     node03.netology.yc   Ready     Active         Reachable        20.10.16
keg8oz8eho9z2jmi3fwvggz1v     node04.netology.yc   Ready     Active                          20.10.16
cwpa3tolwgri9t8n581tmc1dv     node05.netology.yc   Ready     Active                          20.10.16
ifenlaos01rlnl74qw2458wfl     node06.netology.yc   Ready     Active                          20.10.16
```

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

```bash
[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
talbzw5xoj22   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
f6l12a89rc8q   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
vecbm0xq2z7l   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
qjogccl0gudk   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
qo6vo1fcsklq   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
tn0b9brpqjd0   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
quj7m1rlc1a9   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
xdy77w7pvgir   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

