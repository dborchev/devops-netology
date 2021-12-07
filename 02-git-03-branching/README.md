# Домашнее задание к занятию «2.3. Ветвления в Git»
https://github.com/netology-code/sysadm-homeworks/blob/devsys10/02-git-03-branching/README.md

## Задание №1 – Ветвление, merge и rebase. 

1. Создайте в своем репозитории каталог `branching` и в нем два файла `merge.sh` и `rebase.sh`✅

2. Создадим коммит с описанием `prepare for merge and rebase` и отправим его в ветку main. ✅

#### Подготовка файла merge.sh.
1. Создайте ветку `git-merge`. ✅
2. Замените в ней содержимое файла `merge.sh` ✅
3. Создайте коммит `merge: @ instead *` отправьте изменения в репозиторий.✅
4. И разработчик подумал и решил внести еще одно изменение в `merge.sh` ✅ 
5. Создайте коммит `merge: use shift` и отправьте изменения в репозиторий.  ✅ 

#### Изменим main.
1. Вернитесь в ветку `main`.✅
2. Для этого изменим содержимое файла `rebase.sh`✅
3. Отправляем измененную ветку `main` в репозиторий.✅

#### Подготовка файла rebase.sh.
1. найдем хэш коммита `prepare for merge and rebase` и выполним `git checkout` на него ✅
2. Создадим ветку `git-rebase` основываясь на текущем коммите. ✅
3. И изменим содержимое файла `rebase.sh`✅
4. Отправим эти изменения в ветку `git-rebase`, с комментарием `git-rebase 1`.✅
5. И сделаем еще один коммит `git-rebase 2` с пушем заменив `echo "Parameter: $param"` 
на `echo "Next parameter: $param"`. ✅

#### Merge
Сливаем ветку `git-merge` в main и отправляем изменения в репозиторий ✅

#### Rebase
1. Переключаемся на ветку `git-rebase` и выполняем `git rebase -i main`.✅
2. разрешим конфликты ✅
3. запушим ✅
4. смержим `git-merge` в `main` ✅