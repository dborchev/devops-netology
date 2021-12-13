# Домашнее задание к занятию «2.4. Инструменты Git»

>Для выполнения заданий в этом разделе давайте склонируем репозиторий с исходным кодом 
терраформа https://github.com/hashicorp/terraform 

>В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены. 

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`. 
   1. Полный хэш `aefead2207ef7e2aa5dc81a34aedf0cad4c32545`
   2. Находим командой `git show` с `%H` в формате вывода:
```
$ git show "aefea" --no-patch --pretty="%H %s"
aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md
```
2. Какому тегу соответствует коммит `85024d3`?  
   1. тегу `v0.12.23`
   2. находим по команде `git show`:
```
$ git show "85024d3" --no-patch
85024d310  (tag: v0.12.23) v0.12.23
``` 
4. Сколько родителей у коммита `b8d720`? Напишите их хеши.
   1. два: `56cd7859e05c36c06b56d013b55a252d0bb7e158` и `9ea88f22fc6269854151c571162c5bcf958bee2b`
   2. для нахождения всех родителей используем `git rev-parse` и `^@` аппендикс к хэшу:
```
$ git rev-parse b8d720^@
56cd7859e05c36c06b56d013b55a252d0bb7e158
9ea88f22fc6269854151c571162c5bcf958bee2b
```
5. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.
   1. хэши и комендтарии по команде `git log`:
```
$ git log v0.12.23...v0.12.24 --graph
* 33ff1c03b  (tag: v0.12.24) v0.12.24
* b14b74c49  [Website] vmc provider links
* 3f235065b  Update CHANGELOG.md
* 6ae64e247  registry: Fix panic when server is unreachable
* 5c619ca1b  website: Remove links to the getting started guide's old location
* 06275647e  Update CHANGELOG.md
* d5f9411f5  command: Fix bug when using terraform login on Windows
* 4b6d06cc5  Update CHANGELOG.md
* dd01a3507  Update CHANGELOG.md
* 225466bc3  Cleanup after v0.12.23 release
```
6. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточего перечислены аргументы).
   1. функция впервые появилась с коммитом `8c928e835`
   2. используем встроенный регексп команды `git log`, из вывода нас интересует только последняя строка соответствующая самому раннему коммиту:
```
$ git log -G'func providerSource[\(]' | tail -1
8c928e835  main: Consult local directories as potential mirrors of providers
```
7. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.
   1. функция изменена в коммитах `78b122055`, `52dbf9483`,`41ab0aef7`,`66ebff90c`,`8364383c3`
   2. для этого:
найдём где функция находится командой `git grep`:
```
$ git grep 'func globalPluginDirs[\(]'
plugins.go:func globalPluginDirs() []string {
```
найдём где функция измененна командой `git log` с опцией `-L`:

```
$ git log -L:globalPluginDirs:plugins.go --no-patch
78b122055  Remove config.go and update things using its aliases
52dbf9483  keep .terraform.d/plugins for discovery
41ab0aef7  Add missing OS_ARCH dir to global plugin paths
66ebff90c  move some more plugin search path logic to command
8364383c3  Push plugin discovery down into command package
```
8. Кто автор функции `synchronizedWriters`?
   1. функция впервые упоминается в коммите `5ac311e2a` за авторством Martin Atkins mart@degeneration.co.uk
   2. найдем все коммиты содержащие определение `synchronizedWriters` используя встроенный регексп `git log`, используя опции форматирования добавим в вывод идентификаторы авторов (имя и электронная почта), из результата возьмём только последнюю строку:
```
$ git log -G'func synchronizedWriters\(' --pretty="%h %s || %an %ae" | tail -1
5ac311e2a main: synchronize writes to VT100-faker on Windows || Martin Atkins mart@degeneration.co.uk
```