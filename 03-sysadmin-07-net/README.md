# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"
https://github.com/netology-code/sysadm-homeworks/blob/devsys10/03-sysadmin-07-net/README.md


1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
   1. ipconfig в Windows, ifconfig в linux
   2. интерфейсы:
   ```bash
   vagrant@vagrant:~$ ifconfig | grep mtu
   eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
   lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
   ```
