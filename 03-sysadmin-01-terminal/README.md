# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

https://github.com/netology-code/sysadm-homeworks/blob/devsys10/03-sysadmin-01-terminal/README.md

1. Установите средство виртуализации [Oracle VirtualBox](https://www.virtualbox.org/) ✅
2. Установите средство автоматизации [Hashicorp Vagrant](https://www.vagrantup.com/) ✅
3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал ✅
4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:
    * Создайте директорию, в которой будут храниться конфигурационные файлы Vagrant. В ней выполните `vagrant init`. Замените содержимое Vagrantfile по умолчанию следующим:
        ```bash
        Vagrant.configure("2") do |config|
            config.vm.box = "bento/ubuntu-20.04"
        end
        ```
    * Выполнение в этой директории `vagrant up` ✅
    * `vagrant suspend` выключит виртуальную машину с сохранением ее состояния (т.е., при следующем `vagrant up` будут запущены все процессы внутри, которые работали на момент вызова suspend), `vagrant halt` выключит виртуальную машину штатным образом ✅
