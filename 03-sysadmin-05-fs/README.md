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
1. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```
    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.  ✅
