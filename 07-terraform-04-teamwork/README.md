# Домашнее задание к занятию "7.4. Средства командной работы над инфраструктурой."

https://github.com/netology-code/virt-homeworks/blob/virt-11/07-terraform-04-teamwork/README.md

## Задача 1. Настроить terraform cloud
1. Зарегистрируйтесь на [https://app.terraform.io/](https://app.terraform.io/) ✅ 
2. Создайте в своем github аккаунте (или другом хранилище репозиториев) отдельный репозиторий с
 конфигурационными файлами прошлых занятий ✅ 
   1. https://github.com/dborchev/07-terraform-04-teamwork
3. Зарегистрируйте этот репозиторий в [https://app.terraform.io/](https://app.terraform.io/). ✅ 
4. Выполните plan и apply. ✅ 

В качестве результата задания приложите снимок экрана с успешным применением конфигурации.
![screenshots/terraform-cl;oud-plan-apply.png](screenshots/terraform-cl;oud-plan-apply.png)


## Задача 2. Написать серверный конфиг для атлантиса. 
1. Создай `server.yaml`
   1. https://github.com/dborchev/devops-netology/blob/main/teraform/server.yaml
2. Создай `atlantis.yaml`
   1. https://github.com/dborchev/devops-netology/blob/main/teraform/atlantis.yaml

## Задача 3. Знакомство с каталогом модулей.
1. В [каталоге модулей](https://registry.terraform.io/browse/modules) найдите официальный модуль от aws для создания
`ec2` инстансов.
   1. https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest?tab=inputs
2. Изучите как устроен модуль. Задумайтесь, будете ли в своем проекте использовать этот модуль или непосредственно 
ресурс `aws_instance` без помощи модуля?
   1. Модуль конечно крутой, но преимущества для общих случаев неочевидны.
   2. Я не стал бы в проект добавлять зависимости без необходимости. Ресурса достаточно для большинства практических применений.
3. В рамках предпоследнего задания был создан ec2 при помощи ресурса `aws_instance`. 
Создайте аналогичный инстанс при помощи найденного модуля.   

В качестве результата задания приложите ссылку на созданный блок конфигураций. 
 - https://github.com/dborchev/devops-netology/blob/07-terraform-04-teamwork-task-3/teraform/main.tf#L54-L79
