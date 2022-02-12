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
