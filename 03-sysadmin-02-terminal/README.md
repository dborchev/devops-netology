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
5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
   1. получится: `command > out < in`, например:
   ```bash
    vagrant@vagrant:~$ for i in {1..1000}; do echo $i >> test_input.txt ; done
    vagrant@vagrant:~$ tail test_input.txt
    991
    992
    993
    994
    995
    996
    997
    998
    999
    1000
    vagrant@vagrant:~$ grep -v 1 > test_out.txt < test_input.txt
    vagrant@vagrant:~$ tail test_out.txt
    989
    990
    992
    993
    994
    995
    996
    997
    998
    999
    ```
6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
   1. если эмулятор TTY читает и воспроизводит stdin, то получится. Как и в случае выше, "всё -- файл", поэтому мы можем направить вывод PTY в файл tty, что-то вроде
   ```bash
   ls > /dev/pts/42
   ```
   или даже напрямую в fd/1 (stdin) конкретного процесса:
   ```bash
   ls > /proc/$PID/fd/1
   ```
7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит? 
   1. `bash 5>&1` направляет файловый дескриптор 5 нового процесса в stdout текущего
   2. `echo netology > /proc/$$/fd/5` направляет в этот файловый дескриптор вывод `echo`, предыдущая команда возвращает его в наш stdout, в результате мы видим указанную строку у нас:
   ```bash
    vagrant@vagrant:~$ bash 5>&1
    vagrant@vagrant:~$ ps aux | grep bash
    vagrant     1137  0.0  0.4  10100  4264 pts/0    Ss   06:08   0:00 -bash
    vagrant     1367  0.0  0.3   9572  3340 pts/0    T    07:06   0:00 bash
    vagrant     1371  0.0  0.3   9836  4012 pts/0    S    07:11   0:00 bash
    vagrant     1378  0.0  0.0   9032   736 pts/0    S+   07:12   0:00 grep --color=auto bash
    vagrant@vagrant:~$ echo netology > /proc/1371/fd/5
    netology
    ```
8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty?
   1. например так:
   ```bash
   vagrant@vagrant:~$ curl -v -r 0-99 https://curl.se/download.html 42>&1 1>&2 2>&42 42>&-  | grep TLS
   * TLSv1.3 (OUT), TLS handshake, Client hello (1):
   * TLSv1.3 (IN), TLS handshake, Server hello (2):
   * TLSv1.2 (IN), TLS handshake, Certificate (11):
   * TLSv1.2 (IN), TLS handshake, Server key exchange (12):
   * TLSv1.2 (IN), TLS handshake, Server finished (14):
   * TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
   * TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
   * TLSv1.2 (OUT), TLS handshake, Finished (20):
   * TLSv1.2 (IN), TLS handshake, Finished (20):
   * SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
   <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd
   ```
   здесь, последняя строка -- содержимое страницы которую curl посылает на stdout по-умолчанию
9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?
   1. выводит переменные окружения из памяти процесса $$
   2. команда `env` выведет окружение текущей сессии
   3. на произвольный процесс $$ можно также посмотреть используя `ps e $$ | less`
10. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.
    1. без использования `man`, видно, что `/cmdline` содержит массив параметров командной строки вызвавшую процесс `<PID>`, например:
    ```bash
    $ sleep 10000 &
    [1] 2604
    $ less /proc/2604/cmdline
    sleep^@10000^@
    ```
    2. аналогично, можно видеть что `/exe` содержит что-то вроде памяти `text` процесса, судя по бинарному содержимому и упоминаниям `ld-linux`
    3. наконец, используя [man](https://linux.die.net/man/5/proc) можно подтвердить первое наблюдение, и уточнить второе, поскольку `/exe` является ссылкой:
    ```bash
    $ ls  -lah /proc/2604/exe
    lrwxrwxrwx 1 vagrant vagrant 0 Jan 20 07:20 /proc/2604/exe -> /usr/bin/sleep
    ```
11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`
    1. `sse4_2`:
    ```bash
    $ cat /proc/cpuinfo | egrep -o 'sse\S+' | sort -u
    sse2
    sse3
    sse4_1
    sse4_2
    ```
