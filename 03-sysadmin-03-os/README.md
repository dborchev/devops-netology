# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`?
   1. вызов `chdir()`. Сравним например:
   ```bash
   vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep tmp
   execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffc308eb040 /* 24 vars */) = 0
   stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
   chdir("/tmp")                           = 0
   vagrant@vagrant:~$ strace /bin/bash -c 'ls /tmp' 2>&1 | grep tmp
   execve("/bin/bash", ["/bin/bash", "-c", "ls /tmp"], 0x7ffe617c2740 /* 24 vars */) = 0
   execve("/usr/bin/ls", ["ls", "/tmp"], 0x557b5b0acc40 /* 24 vars */) = 0
   read(3, "nodev\tsysfs\nnodev\ttmpfs\nnodev\tbd"..., 1024) = 397
   stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
   openat(AT_FDCWD, "/tmp", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3                          = 0
   ```
2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.
   1. общее (comm) между выводами то, что оно ищет различные файлы "magic", скорее всего это и есть "база данных" libmagic описанной в мане:
   ```bash
   vagrant@vagrant:~$ strace file /dev/sda 2>test_sda
   /dev/sda: block special (8/0)
   vagrant@vagrant:~$ strace file /dev/tty 2>test_tty
   /dev/tty: character special (5/0)
   vagrant@vagrant:~$ strace file /bin/bash 2>test_bash
   /bin/bash: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=a6cb40078351e05121d46daa768e271846d5cc54, for GNU/Linux 3.2.0, stripped
   vagrant@vagrant:~$ sort -u test_sda > sort_sda
   vagrant@vagrant:~$ sort -u test_tty > sort_tty
   vagrant@vagrant:~$ sort -u test_bash > sort_bash
   vagrant@vagrant:~$ comm sort_tty sort_sda > test_dev
   vagrant@vagrant:~$ sort -u test_dev > sort_dev
   vagrant@vagrant:~$ comm sort_dev sort_bash | grep open | grep -v x86_64
     openat(AT_FDCWD, "/bin/bash", O_RDONLY|O_NONBLOCK) = 3
   openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
     openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
     openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
   openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
     openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
   openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
     openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
   openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
     openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
   ```
3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
   1. поскольку это происходит от того, что "файл" существует пока есть хоть одна ссылка (в данном случае - дискриптор) на него; самый простой способ освободить такой файл - перезапустить процесс. Так мы сделать не можем по условию задачи. Можно просто перезапустить всю машину (операционную систему).
   2. воспроизведём ситуацию:
   ```bash
   vagrant@vagrant:~$ wget --limit-rate=19k https://speed.hetzner.de/1GB.bin &
   [1] 4485
   vagrant@vagrant:~$ ls -lah /proc/4485/fd/
   total 0
   dr-x------ 2 vagrant vagrant  0 Jan 22 11:25 .
   dr-xr-xr-x 9 vagrant vagrant  0 Jan 22 11:25 ..
   lrwx------ 1 vagrant vagrant 64 Jan 22 11:25 0 -> /dev/pts/1
   lrwx------ 1 vagrant vagrant 64 Jan 22 11:25 1 -> /dev/pts/1
   lrwx------ 1 vagrant vagrant 64 Jan 22 11:25 2 -> /dev/pts/1
   l-wx------ 1 vagrant vagrant 64 Jan 22 11:25 3 -> /home/vagrant/wget-log.1
   lrwx------ 1 vagrant vagrant 64 Jan 22 11:25 4 -> 'socket:[151969]'
   l-wx------ 1 vagrant vagrant 64 Jan 22 11:25 5 -> /home/vagrant/1GB.bin
   vagrant@vagrant:~$ rm -f 1GB*
   vagrant@vagrant:~$ ls -lah /proc/4485/fd/
   total 0
   dr-x------ 2 vagrant vagrant  0 Jan 22 11:25 .
   dr-xr-xr-x 9 vagrant vagrant  0 Jan 22 11:25 ..
   lrwx------ 1 vagrant vagrant 64 Jan 22 11:25 0 -> /dev/pts/1
   lrwx------ 1 vagrant vagrant 64 Jan 22 11:25 1 -> /dev/pts/1
   lrwx------ 1 vagrant vagrant 64 Jan 22 11:25 2 -> /dev/pts/1
   l-wx------ 1 vagrant vagrant 64 Jan 22 11:25 3 -> /home/vagrant/wget-log.1
   lrwx------ 1 vagrant vagrant 64 Jan 22 11:25 4 -> 'socket:[151969]'
   l-wx------ 1 vagrant vagrant 64 Jan 22 11:25 5 -> '/home/vagrant/1GB.bin (deleted)'   
   ```
   3. поскольку для "обнуления" достаточно записать в целевой файл "ничего", то можем использовать например `echo -n '' > /proc/4485/fd/5` (`-n` чтобы echo не добавляло перенос строки)
4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
   1. нет, поскольку зомби вызвали `exit()`, и ОС высвободила их ресурсы
   2. "немножко" - статус выхода переданный в вызове `exit()` всё равно хранится ОС, и раз мы видим процесс в таблице процессов, значит зомби занимает там соответствующую запись. Так что, несколько байт памяти в области ассоциированной с таблицей процессов зомби процесс продолжает занимать.
5. В iovisor BCC есть утилита `opensnoop`. На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты?
   1. в первую секунду она не успевает ничего, нужно ждать немного дольше:
   ```bash
   root@vagrant:~# timeout 1s /usr/sbin/opensnoop-bpfcc
   PID    COMM               FD ERR PATH
   root@vagrant:~# timeout 2s /usr/sbin/opensnoop-bpfcc
   PID    COMM               FD ERR PATH
   root@vagrant:~# timeout 3s /usr/sbin/opensnoop-bpfcc
   PID    COMM               FD ERR PATH
   root@vagrant:~# timeout 4s /usr/sbin/opensnoop-bpfcc
   PID    COMM               FD ERR PATH
   1      systemd            12   0 /proc/390/cgroup
   1      systemd            12   0 /proc/617/cgroup
   1      systemd            12   0 /proc/598/cgroup
   1      systemd            12   0 /proc/395/cgroup
   791    vminfo              6   0 /var/run/utmp
   603    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
   603    dbus-daemon        18   0 /usr/share/dbus-1/system-services
   603    dbus-daemon        -1   2 /lib/dbus-1/system-services
   603    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
   ```
6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
   1. вызов `uname()`:
   ```bash
   vagrant@vagrant:~$ uname -a
   Linux vagrant 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
   vagrant@vagrant:~$ strace uname -a 2>&1 | grep -B 3 "Linux vagrant"
   fstat(1, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
   uname({sysname="Linux", nodename="vagrant", ...}) = 0
   uname({sysname="Linux", nodename="vagrant", ...}) = 0
   write(1, "Linux vagrant 5.4.0-80-generic #"..., 105Linux vagrant 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
   ```
   2. цитируя [man uname(2)](https://man7.org/linux/man-pages/man2/uname.2.html):
   > Part of the utsname information is also accessible via
       /proc/sys/kernel/{ostype, hostname, osrelease, version,
       domainname}.
7. Чем отличается последовательность команд через `;` и через `&&` в bash? Есть ли смысл использовать в bash `&&`, если применить `set -e`?
   1. `;` просто разделяет команды выполняеемые последовательно:
   ```bash
   $ /bin/false ; echo $?
   1
   ```
   2. `&&` требует успешного (нулевого) кода выхода (и, напротив, `||` требует не-нулевого, т.е. ошибки) для перехода к следующей команде
   ```bash
   vagrant@vagrant:~$ /bin/false && echo $?
   vagrant@vagrant:~$ /bin/true && echo $?
   0
   vagrant@vagrant:~$ /bin/true || echo $?
   vagrant@vagrant:~$ /bin/false || echo $?
   1
   ```
   3. `set -e` приводит к остановке исполнения (всей сессии) при любом не-нулевом коде выхода:
   ```bash
   vagrant@vagrant:~$  set -e
   vagrant@vagrant:~$  /bin/false
   Connection to 127.0.0.1 closed.
   ```
   но ничто не мешает использовать `&&` и `||` для инлайн-управления потоком исполнения, поскольку они оборачивают коды выхода в пайплайне; при `set -e` важен только последний код выхода:
   ```bash
   vagrant@vagrant:~$ set -e
   vagrant@vagrant:~$ /bin/false && echo $?
   vagrant@vagrant:~$ /bin/false && echo OK:$? || echo BAD:$?
   BAD:1
   vagrant@vagrant:~$ /bin/true && echo OK:$? || echo BAD:$?
   OK:0
   vagrant@vagrant:~$ /bin/true && /bin/false || echo BAD:$?
   BAD:1
   vagrant@vagrant:~$ /bin/true && /bin/false
   Connection to 127.0.0.1 closed.
   ```
8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
   1. `-e` - останавливает процесс при ненулевом коде выхода из под-процесса.
   2. `-u` - вызывает ошибку при использовании неинициализированных переменных, что помогает ловить баги в скриптах, в тех местах где через переменные передаются параметры
   3. `-x` - при отладке, приводит к эху команд интерпретатора, чтобы увидеть где произошел останов и какие значение принимали переменные)
   4. `-o pipefail` - устанавливает код возврата цепочки команд в значение возвращенное последней командой с не-нулевым статусом, либо в 0 если все команды успешны
   5. в сумме, мы получаем режим полезный при отладке - выход при любой ошибке, в том числе при использовании неинициализированной переменной, и предоставляет подробный протокол исполнения
9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
   1. `S` (непрерываемый сон, процессы ожидающие некотрого события) и `I` (бездействующие процессы ядра) встречаются наиболее часто в этой системе:
   ```bash
   $ ps ax -o stat | grep -v STAT | tr -d '[a-z][0-9]\++<' | sort | uniq -c | sort -n
      1 R
      1 SL
      2 SN
     47 I
     50 S
   ```