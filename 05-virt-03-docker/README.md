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