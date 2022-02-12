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
2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
   1. разные протоколы: LLDP, CDP, и прочие проприетарные
   2. пакет `lldpad` включает демона, который позволяет работать с LLDP
   3. в пакет входит утилита `lldptool` для работы с протоколом (точнее - для общения с демоном)
3. ...
   1. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? 
      1. IEEE 802.1q
   2. Какой пакет и команды есть в Linux для этого? 
      1. пакет так и называется, `vlan`
      2. устанавливает модуль ядра `8021q`
      3. для управления, включает утилиту `vconfig`, в будущем перейдёт под общую сетевую утилиту `ip`
   3. Приведите пример конфига.
      1. например так:
      ```bash
      vagrant@vagrant:~$ cat /etc/network/interfaces.d/99-test-vlan
      auto eth0.42
      iface eth0.42 inet static
      address 10.1.2.3
      netmask 255.255.255.0
      vlan-raw-device eth0
      ```
      2. с другой стороны, например
      ```cisco
      interface Ethernet0
         switchport mode trunk
         switchport trunk encapsulation dot1q
         switchport trunk allowed vlan 42
      ```
4. ...
   1. Какие типы агрегации интерфейсов есть в Linux?
      1. поддерживаются как стандартный `802.3ad`, некоторые простые режимы резервирования (`active-backup`, `broadcast`), и несколько вариантов балансировки
   2. Какие опции есть для балансировки нагрузки?
      1. "по кругу" (round-robin `balance-rr`)
      2. по хэшу из заголовков пакета (XOR, `balance-xor`)
      3. адаптивный к исходящей нагрузке (Transmit Load Balancing, `balance-tlb`)
      4. адаптивный к двусторонней нагрузке (Adaptive (Transmit + Receive), `balance-alb`)
   3. Приведите пример конфига
   ```bash
   vagrant@vagrant:~$ cat /etc/network/interfaces.d/99-test-bonding
   auto eth0
   iface eth0 inet manual
        bond-master bond0
        bond-primary eth0
   auto eth1
   iface eth1 inet manual
        bond-master bond0
   auto bond0
   iface bond0 inet static
        address 192.168.42.42
        gateway 192.168.42.1
        netmask 255.255.255.0
        bond-mode 802.3ad
        bond-miimon 100
        bond-slaves none
   ```
   с другой стороны например так
   ```cisco
   interface Ethernet0
       channel-group 42 mode active
   interface Ethernet1
       channel-group 42 mode active
   interface port-channel 42
       no shutdown
   ```
   