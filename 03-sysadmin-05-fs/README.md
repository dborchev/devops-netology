# Домашнее задание к занятию "3.5. Файловые системы"
https://github.com/netology-code/sysadm-homeworks/tree/devsys10/03-sysadmin-05-fs

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах. ✅
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
   1. нет, поскольку это один и тотже физический объект (inode), который сожержит метаданные о правах и других атрибутах [man inode(7)](https://man7.org/linux/man-pages/man7/inode.7.html)
   2. попробуем:
   ```bash
   vagrant@vagrant:/tmp/tmp.awRurTQcGU$ touch superfile
   vagrant@vagrant:/tmp/tmp.awRurTQcGU$ ln superfile superlinktosuperfile
   vagrant@vagrant:/tmp/tmp.awRurTQcGU$ ll
   total 8
   drwx------  2 vagrant vagrant 4096 Feb 12 09:30 ./
   drwxrwxrwt 11 root    root    4096 Feb 12 09:29 ../
   -rw-rw-r--  2 vagrant vagrant    0 Feb 12 09:30 superfile
   -rw-rw-r--  2 vagrant vagrant    0 Feb 12 09:30 superlinktosuperfile
   vagrant@vagrant:/tmp/tmp.awRurTQcGU$ chmod +x superlinktosuperfile
   vagrant@vagrant:/tmp/tmp.awRurTQcGU$ ll
   total 8
   drwx------  2 vagrant vagrant 4096 Feb 12 09:30 ./
   drwxrwxrwt 11 root    root    4096 Feb 12 09:29 ../
   -rwxrwxr-x  2 vagrant vagrant    0 Feb 12 09:30 superfile*
   -rwxrwxr-x  2 vagrant vagrant    0 Feb 12 09:30 superlinktosuperfile*
   ```
3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile...
   1. Создал новый: ✅ https://github.com/dborchev/devops-netology/blob/main/03-sysadmin-05-fs/vagrant/Vagrantfile
   3. Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.  ✅
   4. появились `sdb` и `sdc`:
   ```bash
   vagrant@vagrant:~$ lsblk
   NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
   sda                    8:0    0   64G  0 disk
   ├─sda1                 8:1    0  512M  0 part /boot/efi
   ├─sda2                 8:2    0    1K  0 part
   └─sda5                 8:5    0 63.5G  0 part
     ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
     └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
   sdb                    8:16   0  2.5G  0 disk
   sdc                    8:32   0  2.5G  0 disk
   ```
4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
   1. разбил:
   ```bash
   vagrant@vagrant:~$ sudo fdisk -l /dev/sdb
   Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
   Disk model: VBOX HARDDISK
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disklabel type: dos
   Disk identifier: 0xca28c0d0
   
   Device     Boot   Start     End Sectors  Size Id Type
   /dev/sdb1          2048 4196351 4194304    2G 83 Linux
   /dev/sdb2       4196352 5242879 1046528  511M 83 Linux
   ```
5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
   1. ✅
   ```bash
   root@vagrant:/home/vagrant# sfdisk -d /dev/sdb | sfdisk --force /dev/sdc
   Checking that no-one is using this disk right now ... OK
   
   Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
   Disk model: VBOX HARDDISK
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   
   >>> Script header accepted.
   >>> Script header accepted.
   >>> Script header accepted.
   >>> Script header accepted.
   >>> Created a new DOS disklabel with disk identifier 0xca28c0d0.
   /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
   /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
   /dev/sdc3: Done.
   
   New situation:
   Disklabel type: dos
   Disk identifier: 0xca28c0d0
   
   Device     Boot   Start     End Sectors  Size Id Type
   /dev/sdc1          2048 4196351 4194304    2G 83 Linux
   /dev/sdc2       4196352 5242879 1046528  511M 83 Linux
   
   The partition table has been altered.
   Calling ioctl() to re-read partition table.
   Syncing disks.
   ```
6. Соберите `mdadm` RAID1 на паре разделов 2 Гб
   1. ✅
   ```bash
   root@vagrant:/home/vagrant# mdadm --create  /dev/md1 -l 1 -n 2 /dev/sdb1  /dev/sdc1
   mdadm: Note: this array has metadata at the start and
       may not be suitable as a boot device.  If you plan to
       store '/boot' on this device please ensure that
       your boot-loader understands md/v1.x metadata, or use
       --metadata=0.90
   Continue creating array? yes
   mdadm: Defaulting to version 1.2 metadata
   mdadm: array /dev/md1 started.
   root@vagrant:/home/vagrant# fdisk -l /dev/md1
   Disk /dev/md1: 1.102 GiB, 2144337920 bytes, 4188160 sectors
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   ```
7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
   1. ✅
   ```bash
   root@vagrant:/home/vagrant# mdadm --create  /dev/md0 -l 0 -n 2 /dev/sdb2  /dev/sdc2
   mdadm: Defaulting to version 1.2 metadata
   mdadm: array /dev/md0 started.
   root@vagrant:/home/vagrant# fdisk -l /dev/md0
   Disk /dev/md0: 1018 MiB, 1067450368 bytes, 2084864 sectors
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 524288 bytes / 1048576 bytes
   ```
8. Создайте 2 независимых PV на получившихся md-устройствах.
   1. ✅
   ```bash
   root@vagrant:/home/vagrant# pvcreate /dev/md0 /dev/md1
     Physical volume "/dev/md0" successfully created.
     Physical volume "/dev/md1" successfully created.
   ```
9. Создайте общую volume-group на этих двух PV.
   1. ✅
   ```bash
   root@vagrant:/home/vagrant# vgcreate vg0 /dev/md0 /dev/md1
     Volume group "vg0" successfully created
   root@vagrant:/home/vagrant# vgdisplay | grep vg0 -A 20
     VG Name               vg0
     System ID
     Format                lvm2
     Metadata Areas        2
     Metadata Sequence No  1
     VG Access             read/write
     VG Status             resizable
     MAX LV                0
     Cur LV                0
     Open LV               0
     Max PV                0
     Cur PV                2
     Act PV                2
     VG Size               <2.99 GiB
     PE Size               4.00 MiB
     Total PE              765
     Alloc PE / Size       0 / 0
     Free  PE / Size       765 / <2.99 GiB
     VG UUID               zcd3Cf-TdsU-5BsK-hvFM-tUSE-Mdo7-dTfLlr
   ```
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
    1. ✅
   ```bash
   root@vagrant:/home/vagrant# lvcreate --size 100M vg0 /dev/md0
     Logical volume "lvol0" created.
   root@vagrant:/home/vagrant# lvs
     LV     VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
     lvol0  vg0       -wi-a----- 100.00m
     root   vgvagrant -wi-ao---- <62.54g
     swap_1 vgvagrant -wi-ao---- 980.00m
   ```
11. Создайте `mkfs.ext4` ФС на получившемся LV.
    1. ✅
    ```bash
    root@vagrant:/home/vagrant# mkfs.ext4 /dev/vg0/lvol0
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes
    
    Allocating group tables: done
    Writing inode tables: done
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done
    ```
12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`
    1. ✅
    ```bash
    root@vagrant:/home/vagrant# mount /dev/vg0/lvol0 $(mktemp -d)
    root@vagrant:/home/vagrant# mount | grep lvol
    /dev/mapper/vg0-lvol0 on /tmp/tmp.HZSutj1D3Q type ext4 (rw,relatime,stripe=256)
    ```
13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`
    1. ✅
    ```bash
    root@vagrant:/home/vagrant# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/tmp.HZSutj1D3Q/test.gz
    --2022-02-12 10:41:09--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
    Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
    Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 22341182 (21M) [application/octet-stream]
    Saving to: ‘/tmp/tmp.HZSutj1D3Q/test.gz’
    
    /tmp/tmp.HZSutj1D3Q/test.gz      100%[==========================================================>]  21.31M  5.56MB/s    in 4.0s
    
    2022-02-12 10:41:13 (5.29 MB/s) - ‘/tmp/tmp.HZSutj1D3Q/test.gz’ saved [22341182/22341182]
    root@vagrant:/home/vagrant# ll /tmp/tmp.HZSutj1D3Q/
    total 21844
    drwxr-xr-x  3 root root     4096 Feb 12 10:41 ./
    drwxrwxrwt 11 root root     4096 Feb 12 10:36 ../
    drwx------  2 root root    16384 Feb 12 10:33 lost+found/
    -rw-r--r--  1 root root 22341182 Feb 12 09:17 test.gz
    ```
14. Прикрепите вывод `lsblk`
    1. ✅
    ```bash
    root@vagrant:/home/vagrant# lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part  /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
      ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
      └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    ├─sdb1                 8:17   0    2G  0 part
    │ └─md1                9:1    0    2G  0 raid1
    └─sdb2                 8:18   0  511M  0 part
      └─md0                9:0    0 1018M  0 raid0
        └─vg0-lvol0      253:2    0  100M  0 lvm   /tmp/tmp.HZSutj1D3Q
    sdc                    8:32   0  2.5G  0 disk
    ├─sdc1                 8:33   0    2G  0 part
    │ └─md1                9:1    0    2G  0 raid1
    └─sdc2                 8:34   0  511M  0 part
      └─md0                9:0    0 1018M  0 raid0
        └─vg0-lvol0      253:2    0  100M  0 lvm   /tmp/tmp.HZSutj1D3Q
    ```
15. Протестируйте целостность файла:
    1. ✅
    ```bash
    root@vagrant:/home/vagrant# gzip -t /tmp/tmp.HZSutj1D3Q/test.gz
    root@vagrant:/home/vagrant# echo $?
    0
    ```
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
    1. ✅
    ```bash
    root@vagrant:/home/vagrant# pvmove /dev/md0
      /dev/md0: Moved: 20.00%
      /dev/md0: Moved: 100.00%
    root@vagrant:/home/vagrant# lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part  /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
      ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
      └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    ├─sdb1                 8:17   0    2G  0 part
    │ └─md1                9:1    0    2G  0 raid1
    │   └─vg0-lvol0      253:2    0  100M  0 lvm   /tmp/tmp.HZSutj1D3Q
    └─sdb2                 8:18   0  511M  0 part
      └─md0                9:0    0 1018M  0 raid0
    sdc                    8:32   0  2.5G  0 disk
    ├─sdc1                 8:33   0    2G  0 part
    │ └─md1                9:1    0    2G  0 raid1
    │   └─vg0-lvol0      253:2    0  100M  0 lvm   /tmp/tmp.HZSutj1D3Q
    └─sdc2                 8:34   0  511M  0 part
      └─md0                9:0    0 1018M  0 raid0
    ```
