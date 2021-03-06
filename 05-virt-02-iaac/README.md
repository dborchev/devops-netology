
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

https://github.com/netology-code/virt-homeworks/blob/virt-11/05-virt-02-iaac/README.md

## Задача 1

>- Опишите своими словами основные преимущества применения на практике IaaC паттернов.

На мой взгляд важнейшее чего [IaC](https://ru.wikipedia.org/wiki/%D0%98%D0%BD%D1%84%D1%80%D0%B0%D1%81%D1%82%D1%80%D1%83%D0%BA%D1%82%D1%83%D1%80%D0%B0_%D0%BA%D0%B0%D0%BA_%D0%BA%D0%BE%D0%B4) позволяет добиться -- стандартизация понимания инфраструктуры.
Программный код является наиболле точной и однозначно-интерпертируемой системой описания инструкций для некоторого исполнителя. 
Также и схемы инфраструктуры описанные как код понимаются однозначно и людьми, и машинами. 

Мы также можем применять методологии наработанные для программного кода для работы с инфраструктурой управляемой таким образом.
Наиболее очевидным является контроль версий, и храниение инфраструктурного кода в репозиториях.
Более сложным является автоматизация тестирования инфраструктуры. Например, возможно написать тест "используемый балансировщик должен быть типа А", и прерывать развертывание если такой тест неудачен.

Из этого следуют такие высокоуровневые преимущества как сниженеи издержек, надежность, скорость разработки (эволюции).

>- Какой из принципов IaaC является основополагающим?

Воспроизводимость. Так же как исходный код каждый раз компилируется в конкретный исполнимый файл, инфраструктурный код каждый раз приводит к сборке конкретной инфраструктуры.
Если мы откатим репозиторий на 100 коммитов назад, то собранная по нему инфраструктура будет точно такой же, как 100 коммитов назад.

Из этого следуют прочие принципы, такие как повторимость процессов, одноразовость (как следующая из этого неизменяемость).

## Задача 2

>- Чем Ansible выгодно отличается от других систем управление конфигурациями?

Отсутсвтие агента позволяет адаптировать Ансибл для более разнообразных задач.
На целевой системе достаточно присутствие стандартного SSH доступа, и нужный драйвер для Ansible может быть написан.
Так, например, осуществлена вся ранняя поддержка сетевого оборудования.


>-Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

Pull более надежен. В этом случае, репозиторий конфигураций может быть очень простым (вплоть до статических файлов), а отказы изолированы на конкретных дочерних узлах где происходит исполнение.
Отказ же централизованного Push репозитория приводит к отказу всех подчиненных ему деплойментов.

То же с прочими видами отказов, такими как проблемы на каналах связи.


## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

```bash
ubuntu@ip-172-31-3-17:~$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/ubuntu/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Sep 28 2021, 16:10:42) [GCC 9.3.0]
ubuntu@ip-172-31-3-17:~$ vagrant --version
Vagrant 2.2.19
ubuntu@ip-172-31-3-17:~$ VBoxManage --version                                   6.1.32_Ubuntur149290
ubuntu@ip-172-31-3-17:~$ 
```
