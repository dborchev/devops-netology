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
2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию.  ✅ 
   Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
   1. CPU:
   ```bash
   vagrant@vagrant:~$ curl -Ss localhost:9100/metrics | egrep 'node_cpu_sec.+"(idle|system|user)"' | grep -v '#'
   node_cpu_seconds_total{cpu="0",mode="idle"} 566281.09
   node_cpu_seconds_total{cpu="0",mode="system"} 78.45
   node_cpu_seconds_total{cpu="0",mode="user"} 71.11
   node_cpu_seconds_total{cpu="1",mode="idle"} 566132.11
   node_cpu_seconds_total{cpu="1",mode="system"} 122.06
   node_cpu_seconds_total{cpu="1",mode="user"} 57.06
   ```
   2. память:
   ```bash
   vagrant@vagrant:~$ curl -Ss localhost:9100/metrics | egrep '(node_memory_Mem)' | grep -v '#'
   node_memory_MemAvailable_bytes 7.15476992e+08
   node_memory_MemFree_bytes 1.94097152e+08
   node_memory_MemTotal_bytes 1.028694016e+09
   ```
   3. диск:
   ```bash
   vagrant@vagrant:~$ curl -Ss localhost:9100/metrics | egrep 'node_disk.+_seconds_.+"sd[a-z]"' | grep -v '#'
   node_disk_discard_time_seconds_total{device="sda"} 0
   node_disk_io_time_seconds_total{device="sda"} 40.368
   node_disk_io_time_weighted_seconds_total{device="sda"} 15.476
   node_disk_read_time_seconds_total{device="sda"} 6.932
   node_disk_write_time_seconds_total{device="sda"} 44.599000000000004
   ```
   4. сеть:
   ```bash
   vagrant@vagrant:~$ curl -Ss localhost:9100/metrics | egrep 'node_network.+(errs|bytes)_t.+"eth[0-9]"' | grep -v '#'
   node_network_receive_bytes_total{device="eth0"} 8.1852297e+07
   node_network_receive_errs_total{device="eth0"} 0
   node_network_transmit_bytes_total{device="eth0"} 3.568308e+06
   node_network_transmit_errs_total{device="eth0"} 0
   ```
3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata).  ✅ После успешной установки:
   * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
   ```bash
   vagrant@vagrant:~$ sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/netdata/netdata.conf
   vagrant@vagrant:~$ grep bind /etc/netdata/netdata.conf
   bind socket to IP = 0.0.0.0
   vagrant@vagrant:~$ service netdata start
   ==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
   Authentication is required to start 'netdata.service'.
   Authenticating as: vagrant,,, (vagrant)
   Password:
   ==== AUTHENTICATION COMPLETE ===
   vagrant@vagrant:~$ sudo netstat -anp -t | grep netdata
   tcp        0      0 127.0.0.1:8125          0.0.0.0:*               LISTEN      8808/netdata
   tcp        0      0 0.0.0.0:19999           0.0.0.0:*               LISTEN      8808/netdata
   tcp6       0      0 ::1:8125                :::*                    LISTEN      8808/netdata
   ```
   * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:
   ```bash
     config.vm.network "forwarded_port", guest: 19999, host: 19999
   ```
   [✅](https://github.com/dborchev/devops-netology/blob/main/03-sysadmin-01-terminal/vagrant/Vagrantfile) 
