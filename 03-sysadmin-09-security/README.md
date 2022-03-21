# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"
https://github.com/netology-code/sysadm-homeworks/blob/devsys10/03-sysadmin-09-security/README.md

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей. ✅ 
2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.  ✅ 
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.
   1. ✅ 
   ```bash
   vagrant@vagrant:~$ sudo apt install apache2
   ...                            //snip
   vagrant@vagrant:~$ sudo a2enmod ssl
   Considering dependency setenvif for ssl:
   Module setenvif already enabled
   Considering dependency mime for ssl:
   Module mime already enabled
   Considering dependency socache_shmcb for ssl:
   Enabling module socache_shmcb.
   Enabling module ssl.
   See /usr/share/doc/apache2/README.Debian.gz on how to configure SSL and create self-signed certificates.
   To activate the new configuration, you need to run:
     systemctl restart apache2
   vagrant@vagrant:~$ sudo systemctl restart apache2
   vagrant@vagrant:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
   Generating a RSA private key
   .............................................................................................................................+++++
   .................................+++++
   writing new private key to '/etc/ssl/private/apache-selfsigned.key'
   -----
   You are about to be asked to enter information that will be incorporated
   into your certificate request.
   What you are about to enter is what is called a Distinguished Name or a DN.
   There are quite a few fields but you can leave some blank
   For some fields there will be a default value,
   If you enter '.', the field will be left blank.
   -----
   Country Name (2 letter code) [AU]:
   string is too long, it needs to be no more than 2 bytes long
   Country Name (2 letter code) [AU]:AU
   State or Province Name (full name) [Some-State]:Foo
   Locality Name (eg, city) []:Bar
   Organization Name (eg, company) [Internet Widgits Pty Ltd]:netologyhomework
   Organizational Unit Name (eg, section) []:Baz
   Common Name (e.g. server FQDN or YOUR name) []:localhost
   Email Address []:webmaster@localhost
   vagrant@vagrant:~$ sudo nano /etc/apache2/sites-available/localhost.conf
   vagrant@vagrant:~$ cat /etc/apache2/sites-available/localhost.conf
   <VirtualHost 127.0.0.1:443>
      ServerName localhost
      DocumentRoot /var/www/
      SSLEngine on
      SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
      SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
   </VirtualHost>
   vagrant@vagrant:~$ sudo a2ensite localhost.conf
   Enabling site localhost.
   To activate the new configuration, you need to run:
   vagrant@vagrant:~$ sudo apache2ctl configtest
   Syntax OK
   vagrant@vagrant:~$ sudo systemctl reload apache2
   ```
4. Проверьте на TLS уязвимости произвольный сайт в интернете
   1. не ясно, что автор имеет ввиду под "уязвимостями", но вот например всесторонний анализ качества TLS отдельно взятого сайта: https://www.ssllabs.com/ssltest/analyze.html?d=askbow.com
5. ...
   1. Установите на Ubuntu ssh сервер, 
      1. sshd установлен по-умолчанию  ✅ 
   2. сгенерируйте новый приватный ключ. 
      1. ✅ 
      ```bash
      vagrant@vagrant:~$ ssh-keygen
      Generating public/private rsa key pair.
      Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
      Enter passphrase (empty for no passphrase):
      Enter same passphrase again:
      Your identification has been saved in /home/vagrant/.ssh/id_rsa
      Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
      The key fingerprint is:
      ...               // snip
      The key's randomart image is:
      ...               // snip
      ```
   3. Скопируйте свой публичный ключ на другой сервер
      1. ✅ 
      ```bash
      ssh-copy-id -i $HOME/.ssh/id_rsa.pub ec2-user@203.0.113.42
      ```
   5. Подключитесь к серверу по SSH-ключу.
      1. ✅ 
      ```bash
      ssh ec2-user@203.0.113.42
      ```
6. ...
   1. Переименуйте файлы ключей из задания 5.
      1. ✅ 
      ```bash
      vagrant@vagrant:~$ ll /home/vagrant/.ssh/
      total 24
      drwx------ 2 vagrant root    4096 Mar 21 11:28 ./
      drwxr-xr-x 7 vagrant vagrant 4096 Feb 12 09:47 ../
      -rw------- 1 vagrant vagrant  389 Jan 10 07:18 authorized_keys
      -rw------- 1 vagrant vagrant 2602 Mar 21 11:28 id_rsa
      -rw-r--r-- 1 vagrant vagrant  569 Mar 21 11:28 id_rsa.pub
      -rw-r--r-- 1 vagrant vagrant  222 Jan 20 07:53 known_hosts
      vagrant@vagrant:~$ for f in  /home/vagrant/.ssh/id* ; do mv "$f" "$(echo "$f" | sed s/rsa/foobar/)"; done
      vagrant@vagrant:~$ ll /home/vagrant/.ssh/
      total 24
      drwx------ 2 vagrant root    4096 Mar 21 12:23 ./
      drwxr-xr-x 7 vagrant vagrant 4096 Feb 12 09:47 ../
      -rw------- 1 vagrant vagrant  389 Jan 10 07:18 authorized_keys
      -rw------- 1 vagrant vagrant 2602 Mar 21 11:28 id_foobar
      -rw-r--r-- 1 vagrant vagrant  569 Mar 21 11:28 id_foobar.pub
      -rw-r--r-- 1 vagrant vagrant  222 Jan 20 07:53 known_hosts
      ```
   2. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
      1. ✅ 
      ```bash
      vagrant@vagrant:~$ grep foobar ~/.ssh/config -A 3 
      Host foobar
         Hostname 203.0.113.42
         Protocol 2
         IdentityFile ~/.ssh/id_foobar
      ```

7. ...
   1. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. 
      1. ...
      ```bash
      vagrant@vagrant:~$ sudo tcpdump -c 100 -w file.pcap &
      [1] 3339
      vagrant@vagrant:~$ tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
      vagrant@vagrant:~$ ping 1.1.1.1 -i 0.2 -c 100
      PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
      ...     // snip
      100 packets captured
      101 packets received by filter
      0 packets dropped by kernel
      ...      // snip
      --- 1.1.1.1 ping statistics ---
      100 packets transmitted, 100 received, 0% packet loss, time 20588ms
      rtt min/avg/max/mdev = 9.463/11.305/16.654/1.327 ms
      [1]+  Done                    sudo tcpdump -c 100 -w file.pcap
      ```
   2. Откройте файл pcap в Wireshark. ✅ 
