# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"
https://github.com/netology-code/sysadm-homeworks/blob/devsys10/03-sysadmin-06-net/README.md

1. Работа c HTTP через телнет.
   - Подключитесь утилитой телнет к сайту stackoverflow.com ✅
   - отправьте HTTP запрос
   ```bash
   vagrant@vagrant:~$ telnet stackoverflow.com 80
   Trying 151.101.65.69...
   Connected to stackoverflow.com.
   Escape character is '^]'.
   GET /questions HTTP/1.0
   HOST: stackoverflow.com
   
   HTTP/1.1 301 Moved Permanently
   cache-control: no-cache, no-store, must-revalidate
   location: https://stackoverflow.com/questions
   x-request-guid: 0790993e-36be-497e-8047-faa556c58f97
   feature-policy: microphone 'none'; speaker 'none'
   content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
   Accept-Ranges: bytes
   Date: Sat, 12 Feb 2022 12:22:04 GMT
   Via: 1.1 varnish
   Connection: close
   X-Served-By: cache-fra19130-FRA
   X-Cache: MISS
   X-Cache-Hits: 0
   X-Timer: S1644668524.490754,VS0,VE86
   Vary: Fastly-SSL
   X-DNS-Prefetch-Control: off
   Set-Cookie: prov=6baaf503-b4ab-203a-2b53-de827ac91926; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly
   
   Connection closed by foreign host.
   ```
   - В ответе укажите полученный HTTP код, что он означает?
     - `301`
     - "редирект" - указывает куда пойти с таким запросом
     - в данном случае, нам намекают, что нужно использовать HTTPS
2. Повторите задание 1 в браузере, используя консоль разработчика F12. ✅
   - откройте вкладку `Network` ✅
   - отправьте запрос http://stackoverflow.com ✅
   - найдите первый ответ HTTP сервера, откройте вкладку `Headers` ✅
   - укажите в ответе полученный HTTP код.
     - `301`
   - проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
     - загрузка страницы после редиректа заняла 165ms
   - приложите скриншот консоли браузера в ответ:
   ![browswer-screeshot](https://github.com/dborchev/devops-netology/blob/main/03-sysadmin-06-net/browser-screenshot.png?raw=true)
3. Какой IP адрес у вас в интернете?
   1. красивый ✅
   ```bash
   vagrant@vagrant:~$ curl ifconfig.me
   203.0.113.42
   ```
4. Это скорее, мысленный эксперимент 😉
   1. Какому провайдеру принадлежит ваш IP адрес? 
      1. никакому, но почему бы и не APNIC:
      ```bash
      vagrant@vagrant:~$ whois 203.0.113.42 | grep mnt-by
      mnt-by:         APNIC-HM
      mnt-by:         MAINT-AU-APNIC-GM85-AP
      mnt-by:         APNIC-HM
      mnt-by:         APNIC-ABUSE
      mnt-by:         MAINT-APNIC-AP
      ```
   2. Какой автономной системе AS? 
      1. никакой, но раз уж взялись, будет 65542:
      ```bash
      vagrant@vagrant:~$ whois 203.0.113.42 | grep origin
      origin:         AS65542
      ```
   3. Воспользуйтесь утилитой `whois` ✅
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`
   1. см. вывод:
   ```bash
   vagrant@vagrant:~$ traceroute -An 8.8.8.8 -q 1
   traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
    1  203.0.113.42 [AS65542]  0.916 ms
    2  100.65.34.184 [*]  2.428 ms
    3  100.66.11.12 [*]  20.347 ms
    4  100.66.18.78 [*]  19.647 ms
    5  241.0.10.75 [*]  0.426 ms
    6  100.66.5.115 [*]  19.772 ms
    7  100.65.15.139 [*]  4.551 ms
    8  100.95.19.159 [*]  1.502 ms
    9  100.100.2.42 [*]  1.027 ms
   10  100.100.2.14 [*]  1.392 ms
   11  99.82.176.189 [*]  1.847 ms
   12  8.8.8.8 [AS15169]  1.361 ms
   ```
