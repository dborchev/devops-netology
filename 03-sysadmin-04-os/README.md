# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"


1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:
Поместите его в автозагрузку, предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`), удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается. 
   1. добавил конфиг: [`/etc/systemd/system/node_exporter.service`](https://github.com/dborchev/devops-netology/blob/main/03-sysadmin-04-os/node_exporter.service)
   2. конфиг отрабатывает, включая считывание переменных окружения из файла:
   ```bash
   vagrant@vagrant:~$ sudo touch /etc/node_exporter
   vagrant@vagrant:~$ systemctl start node_exporter
   ==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
   Authentication is required to start 'node_exporter.service'.
   Authenticating as: vagrant,,, (vagrant)
   Password:
   ==== AUTHENTICATION COMPLETE ===
   vagrant@vagrant:~$ ps -e | grep node_exporter
   7183 ?        00:00:00 node_exporter
   vagrant@vagrant:~$ systemctl stop node_exporter
   ==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
   Authentication is required to stop 'node_exporter.service'.
   Authenticating as: vagrant,,, (vagrant)
   Password:
   ==== AUTHENTICATION COMPLETE ===
   vagrant@vagrant:~$ ps -e | grep node_exporter
   vagrant@vagrant:~$  sudo -i
   root@vagrant:~#  echo 'TESTENVVAR=foobar' > /etc/node_exporter
   root@vagrant:~# cat /etc/node_exporter
   TESTENVVAR=foobar
   root@vagrant:~# exit
   logout
   vagrant@vagrant:~$ cat  /etc/node_exporter
   TESTENVVAR=foobar
   vagrant@vagrant:~$ systemctl stop node_exporter
   ==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
   Authentication is required to stop 'node_exporter.service'.
   Authenticating as: vagrant,,, (vagrant)
   Password:
   ==== AUTHENTICATION COMPLETE ===
   vagrant@vagrant:~$ systemctl start node_exporter
   ==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
   Authentication is required to start 'node_exporter.service'.
   Authenticating as: vagrant,,, (vagrant)
   Password:
   ==== AUTHENTICATION COMPLETE ===
   vagrant@vagrant:~$ ps -e | grep node_exporter
   7307 ?        00:00:00 node_exporter
   vagrant@vagrant:~$ sudo grep -E -z 'TEST' /proc/7307/environ
   TESTENVVAR=foobar
   vagrant@vagrant:~$ sudo netstat -anp -t | grep node
   tcp6       0      0 :::9100                 :::*                    LISTEN      7307/node_exporter
   vagrant@vagrant:~$ curl localhost:9100/metrics | head
   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
   100 61439    0 61439    0     0  5999k      0 --:--:-- --:--:-- --:--:-- 5999k
   # HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
   # TYPE go_gc_duration_seconds summary
   go_gc_duration_seconds{quantile="0"} 0
   go_gc_duration_seconds{quantile="0.25"} 0
   go_gc_duration_seconds{quantile="0.5"} 0
   go_gc_duration_seconds{quantile="0.75"} 0
   go_gc_duration_seconds{quantile="1"} 0
   go_gc_duration_seconds_sum 0
   go_gc_duration_seconds_count 0
   # HELP go_goroutines Number of goroutines that currently exist.
   ```
