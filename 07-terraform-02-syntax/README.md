# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

https://github.com/netology-code/virt-homeworks/blob/virt-11/07-terraform-02-syntax/README.md

## Задача 1 (вариант с AWS). Регистрация в aws и знакомство с основами 

1. Создайте аккаут aws.✅
2. Установите c aws-cli https://aws.amazon.com/cli/. ✅
3. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html. ✅
4. Создайте IAM политику для терраформа ✅
5. Добавьте переменные окружения ✅
6. Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс. ✅

>В виде результата задания приложите вывод команды `aws configure list`.

```bash
$ aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************IOM7              env
secret_key     ****************XY0R              env
    region                eu-west-1      config-file    ~/.aws/config
```
