# Домашнее задание к занятию "7.1. Инфраструктура как код"

https://github.com/netology-code/virt-homeworks/blob/virt-11/07-terraform-01-intro/README.md

## Задача 1. Выбор инструментов.

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
   1. Неизменяемая инфраструктура подходит лучше, поскольку по условиям у нас уже есть практика использования средств шаблонизации систем и инфраструткуры
   2. это также "чище" ложится на необходимость поддержки большого количества небольших релизов и откатов, например откат -- это просто `git revert && git push`
2. Будет ли центральный сервер для управления инфраструктурой?
   1. для тех инструментов к которым мы имеем доступ центральный сервер не нужен, так что по-началу (пока разрабатываем) наверное его не будет
   2. искуственно централизовать систему развертывания инфраструктуры для любого достаточно сложного проекта (сложного в части числа взаимоджействующих систем и команд) -- необходимость. 
      1. Так можно обеспечить стандартизацию процесса (каждый коммит проходит некий пайплайн от сборки и тестирования до прода) и отсутствие прямого доступа людей в прод (чтобы гарантировать "неизменяемость" инфраструктуры).
      2. у нас уже есть TeamCity для таких задач -- по сути сервер этой системы станет центральным сервером управления инфраструктурой, запуская Teraform, сборку образов контейнеров, и т.п.
3. Будут ли агенты на серверах?
   1. для управления инфраструкторой -- не будет
   2. будут агенты для мониторинга, но это похоже лежит за рамками вопроса
4. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов?
   1. да, раз уж мы уже активно используем Teraform, то стоит прододжэать

5. Какие инструменты из уже используемых вы хотели бы использовать для нового проекта? 
   1. то, с чем уже много работаем: Terraform, Docker / Kubernetes, Teamcity
   2. собственно базовые машины под контейнерную инфраструктуру можно поднимать xthtp Packer / Ansible
   3. всегда найдется место для bash-скриптов
6. Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта?
   1. нет, не хочу™
   2. нам уже "скучно не будет" по внутренним причинам проекта, добавление новых неизвестных в уравнение не принесёт нам радости

## Задача 2. Установка терраформ. 

>Официальный сайт: https://www.terraform.io/
>
>Установите терраформ при помощи менеджера пакетов используемого в вашей операционной системе.
>В виде результата этой задачи приложите вывод команды `terraform --version`.

```bash
$ terraform --version
Terraform v1.2.3
on linux_amd64
```

## Задача 3. Поддержка легаси кода. 

>В какой-то момент вы обновили терраформ до новой версии, например с 0.12 до 0.13. 
>А код одного из проектов настолько устарел, что не может работать с версией 0.13. 
>В связи с этим необходимо сделать так, чтобы вы могли одновременно использовать последнюю версию терраформа установленную при помощи
>штатного менеджера пакетов и устаревшую версию 0.12. 
>
>В виде результата этой задачи приложите вывод `--version` двух версий терраформа доступных на вашем компьютере 
>или виртуальной машине.

```bash
~$ terraform012 --version
Terraform v0.12.0

Your version of Terraform is out of date! The latest version
is 1.2.3. You can update by downloading from www.terraform.io/downloads.html
~$ terraform013 --version

Your version of Terraform is out of date! The latest version
is 1.2.3. You can update by downloading from https://www.terraform.io/downloads.html
Terraform v0.13.0
```