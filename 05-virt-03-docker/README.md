# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

https://github.com/netology-code/virt-homeworks/blob/virt-11/05-virt-03-docker/README.md



## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

1. https://hub.docker.com/repository/docker/askbow/netology-05-virt-03-docker-nginx-task1
2. ...
```bash
vagrant@vagrant:~$ cat Dockerfile
FROM nginx:alpine
RUN echo -e '<html>\n<head>\nHey, Netology\n</head>\n<body>\n<h1>I’m DevOps Engineer!</h1>\n</body>\n</html>' > /usr/share/nginx/html/index.html

vagrant@vagrant:~$ sudo docker build - < Dockerfile
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM nginx:alpine
 ---> 51696c87e77e
Step 2/2 : RUN echo -e '<html>\n<head>\nHey, Netology\n</head>\n<body>\n<h1>I’m DevOps Engineer!</h1>\n</body>\n</html>' > /usr/share/nginx/html/index.html
 ---> Running in 5d36e8f83217
Removing intermediate container 5d36e8f83217
 ---> 6e5263231ba9
Successfully built 6e5263231ba9
vagrant@vagrant:~$ sudo docker run 6e5263231ba9
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/05/15 14:26:25 [notice] 1#1: using the "epoll" event method
2022/05/15 14:26:25 [notice] 1#1: nginx/1.21.6
2022/05/15 14:26:25 [notice] 1#1: built by gcc 10.3.1 20211027 (Alpine 10.3.1_git20211027)
2022/05/15 14:26:25 [notice] 1#1: OS: Linux 5.4.0-80-generic
2022/05/15 14:26:25 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/05/15 14:26:25 [notice] 1#1: start worker processes
2022/05/15 14:26:25 [notice] 1#1: start worker process 32
2022/05/15 14:26:25 [notice] 1#1: start worker process 33
^C2022/05/15 14:26:28 [notice] 1#1: signal 2 (SIGINT) received, exiting
2022/05/15 14:26:28 [notice] 33#33: exiting
2022/05/15 14:26:28 [notice] 32#32: exiting
2022/05/15 14:26:28 [notice] 32#32: exit
2022/05/15 14:26:28 [notice] 33#33: exit
2022/05/15 14:26:28 [notice] 1#1: signal 17 (SIGCHLD) received from 32
2022/05/15 14:26:28 [notice] 1#1: worker process 32 exited with code 0
2022/05/15 14:26:28 [notice] 1#1: signal 29 (SIGIO) received
2022/05/15 14:26:28 [notice] 1#1: signal 17 (SIGCHLD) received from 33
2022/05/15 14:26:28 [notice] 1#1: worker process 33 exited with code 0
2022/05/15 14:26:28 [notice] 1#1: exit
vagrant@vagrant:~$ sudo docker container ls --all | grep 6e5263231ba9
5459695ce75a   6e5263231ba9                                       "/docker-entrypoint.…"   About a minute ago   Exited (0) About a minute ago             affectionate_edison
vagrant@vagrant:~$ sudo docker container commit 5459695ce75a askbow/netology-05-virt-03-docker-nginx-task1:latest
sha256:d23c986a16436220d827beb4edb31daa15ac327abf4caaa0a0d1beb89dfa85ec
vagrant@vagrant:~$ sudo docker image tag askbow/netology-05-virt-03-docker-nginx-task1:latest askbow/netology-05-virt-03-docker-nginx-task1:latest
vagrant@vagrant:~$ sudo docker push askbow/netology-05-virt-03-docker-nginx-task1:latest
The push refers to repository [docker.io/askbow/netology-05-virt-03-docker-nginx-task1]
d3614cb641d1: Pushed
801808314a1b: Pushed
b991c80c3ef2: Layer already exists
8df6b63c60d4: Layer already exists
d63b53686463: Layer already exists
c0b09410617a: Layer already exists
be9057e6dae4: Layer already exists
4fc242d58285: Layer already exists
latest: digest: sha256:15181e6fea3fc12732669832e302624a78d77465fa154f620cd64417849d3028 size: 1982
vagrant@vagrant:~$ sudo docker run -d -p 80:80 askbow/netology-05-virt-03-docker-nginx-task1:latest
344bffeee56be3d8aa1fb08b3b123149759a6a47c7d30e8a7b09a0e0ac6ef289
vagrant@vagrant:~$ curl localhost
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```


## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарии:

- Высоконагруженное монолитное java веб-приложение;
  - для собственно приложения -- физический сервер, чтобы (а) не было лишних прослоек, (б) не пытаться бороться с монолитом. Поскольку высоконагруженность бывает разная, то прием большого числа входящих соединений с TLS можно реализовать на контейнерах с nginx с конфигом прокси. Это снимет часть неспецифичной нагрузки с монолита
- Nodejs веб-приложение;
  - контейнеры, поскольку они облегчают и стандартизируют сборку, и доступны готовые образы с nodejs
- Мобильное приложение c версиями для Android и iOS;
  - поскольку нужно запускать под системами со специализированным графическим интерфейсом, то лучше подойдут виртуальные машины
- Шина данных на базе Apache Kafka;
  - контейнеры, если остальная инфраструктура -- в контейнерах, поскольку в кластере Кафки брокеров можно привязать к группам отказов (нс физичесикми серверами, это будут стойки, с контейнерами -- ноды), таким образом обеспечив нажедную работу кластера; в документации на готовые образы контейнеров уже освящена проблема с персистентностью и её решение -- Volume
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
  - можно применить контейнеры, так же как и виртуальным машины, физические сервера -- все зависит от комфорта команды ответственной за поддержку, технически же логгирование скорее упирается в дисковые подсистемы. При применение контейнеров, решение доступа к хранилищу такое же как и в случае с Кафкой
- Мониторинг-стек на базе Prometheus и Grafana;
  - можно применять контейнеры, см.например 
    - https://prometheus.io/docs/prometheus/latest/installation/#using-docker
    - https://grafana.com/docs/grafana/latest/installation/docker/
- MongoDB, как основное хранилище данных для java-приложения;
  - также как и выше, см.например https://www.mongodb.com/docs/manual/tutorial/install-mongodb-enterprise-with-docker/ шже указан путь по развертыванию в энтерпрайз-среде
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
  - также как и выше, см.например https://docs.gitlab.com/ee/install/docker.html

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```bash
vagrant@vagrant:~$ mkdir -p /opt/docker/data
vagrant@vagrant:~$ sudo docker run -d -i -v /opt/docker/data:/data centos:latest /bin/bash
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
acf13fb309aa998b308b966583476dccf0a54f4ec0ec56776001821c02bdb3db
vagrant@vagrant:~$ sudo docker ps
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS          PORTS     NAMES
acf13fb309aa   centos:latest   "/bin/bash"   13 seconds ago   Up 10 seconds             confident_tereshkova
vagrant@vagrant:~$ sudo docker run -d -i -v /opt/docker/data:/data debian:latest /bin/bash
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
67e8aa6c8bbc: Pull complete
Digest: sha256:6137c67e2009e881526386c42ba99b3657e4f92f546814a33d35b14e60579777
Status: Downloaded newer image for debian:latest
80943d5ff2ffd6b20263255be5f7734507a8b9b45a785b3fed70f742d989c1b6
vagrant@vagrant:~$ sudo docker ps
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS          PORTS     NAMES
80943d5ff2ff   debian:latest   "/bin/bash"   27 seconds ago   Up 24 seconds             charming_davinci
acf13fb309aa   centos:latest   "/bin/bash"   2 minutes ago    Up 2 minutes              confident_tereshkova10
vagrant@vagrant:~$ sudo docker exec -i -t acf13fb309aa bash
[root@acf13fb309aa /]# cd data
[root@acf13fb309aa data]# echo test > test.txt
[root@acf13fb309aa data]# ls
test.txt
[root@acf13fb309aa data]# exit
exit
vagrant@vagrant:~$ sudo cp /opt/docker/data/test.txt /opt/docker/data/hosttest.txt
vagrant@vagrant:~$ sudo docker exec -i -t 80943d5ff2ff bash
root@80943d5ff2ff:/# ls /data
hosttest.txt  test.txt
root@80943d5ff2ff:/# cat /data/*
test
test
root@80943d5ff2ff:/# exit
exit

```