# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"


1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.
   1. `cd` - встроенная команда интерпретатора
   2. на практике, для неё вывод команд `which`, `man` пуст:
    ```bash
    $ which cd
    vagrant@vagrant:~$ man cd
    No manual entry for cd
    vagrant@vagrant:~$
    ```
    сравним, например, с `pwd`, `mkdir`, `ls`:
    ```bash
    vagrant@vagrant:~$ which mkdir
    /usr/bin/mkdir
    vagrant@vagrant:~$ which pwd
    /usr/bin/pwd
    vagrant@vagrant:~$ which ls
    /usr/bin/ls
    vagrant@vagrant:~$ man ls | head -1
    LS(1)                                                    User Commands                                                    LS(1)
    vagrant@vagrant:~$ man pwd | head -1
    PWD(1)                                                   User Commands                                                   PWD(1)
    vagrant@vagrant:~$ man mkdir | head -1
    MKDIR(1)                                                 User Commands                                                 MKDIR(1)
    ```
   3. более фундаментально, см. например в https://man7.org/linux/man-pages/man1/cd.1p.html
   > Since cd affects the current shell execution environment, it is
       always provided as a shell regular built-in.
   - поскольку команда влияет на текущее окружение, она должна быть встроенной; дочерние процессы не могут влиять на окружение родителей
2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`?
   1. можно использовать параметр `-c`: `grep -c <some_string> <some_file>`
   2. другой популярной ошибкой с пайпами является `cat <some_file> | grep <some_string>`
3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
   1. `init`:
    ```bash
    vagrant@vagrant:~$ ps aux | grep -E '^[a-z]+\s+1\s+'
    root           1  0.0  1.1 101804 11264 ?        Ss   06:08   0:01 /sbin/init
    ```
4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?
   1. `ls 2>/dev/pts/42`, где `pts/42` - идентификатор целевой сессии в выводе `who` (либо `tty`, если эта сессия достпна интерактивно)

