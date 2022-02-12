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
