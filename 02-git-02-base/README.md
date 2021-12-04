задание https://github.com/netology-code/sysadm-homeworks/blob/devsys10/02-git-02-base/README.md

## Задание №1 – Знакомимся с gitlab и bitbucket 

1. Создадим аккаунт в gitlab, если у вас его еще нет: ♻✅ https://gitlab.com/askbow/devops-netology
2. Теперь необходимо проделать все тоже самое с bitbucket ♻✅ https://bitbucket.org/dborchev/devops-netology/src/main/

## Задание №2 – Теги

1. Создайте легковестный тег `v0.0` на HEAD коммите и запуште его во все три добавленных на предыдущем этапе `upstream` ✅ 
1. Аналогично создайте аннотированный тег `v0.1` ✅
1. Перейдите на страницу просмотра тегов в гитхабе (и в других репозиториях) и посмотрите, чем отличаются созданные теги. 
    * В гитхабе – https://github.com/dborchev/devops-netology/tags
    * В гитлабе – https://gitlab.com/askbow/devops-netology/-/tags
    * В битбакете – https://bitbucket.org/dborchev/devops-netology/commits/tag/v0.1

## Задание №3 – Ветки 

Давайте посмотрим, как будет выглядеть история коммитов при создании веток. 

1. Переключитесь обратно на ветку `main`, которая должна быть связана с веткой `main` репозитория на `github` ✅
2. Посмотрите лог коммитов и найдите хеш коммита с названием `Prepare to delete and move`, который был создан в пределах предыдущего домашнего задания. 
   + `4cb4477  Prepare to delete and move`
3. Выполните `git checkout` по хешу найденного коммита ✅
4. Создайте новую ветку `fix` базируясь на этом коммите `git switch -c fix`✅
5. Отправьте новую ветку в репозиторий на гитхабе `git push -u origin fix`✅
6. Посмотрите, как визуально выглядит ваша схема коммитов: https://github.com/dborchev/devops-netology/network ✅
7. Теперь измените содержание файла `README.md`, добавив новую строчку✅
8. Отправьте изменения в репозиторий и посмотрите, как изменится схема на странице https://github.com/dborchev/devops-netology/network  ✅
и как изменится вывод команды `git log`✅
