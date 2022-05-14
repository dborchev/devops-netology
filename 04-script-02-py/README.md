# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

https://github.com/netology-code/sysadm-homeworks/blob/devsys10/04-script-02-py/README.


## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | никакое, возникнет `TypeError: unsupported operand type(s) for +: 'int' and 'str'`  |
| Как получить для переменной `c` значение 12?  | `c = str(a) + b`, можно обернуть в `int()`, если нужно число 12  |
| Как получить для переменной `c` значение 3?  | `c = a + int(b)`, можно обернуть в `str()`, если нужна строка "3"  |


## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

repo = os.getcwd()

bash_command = [f"cd {repo}", "git ls-files -dmo"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.splitlines():
    print(os.path.join(repo, result.strip()))

```

### Вывод скрипта при запуске при тестировании:
```
$ python 04-script-02-py/show_git_mod.py
C:/Users/Askbow/PycharmProjects/sysadm-homeworks/devops-netology\04-script-02-py/README.md
C:/Users/Askbow/PycharmProjects/sysadm-homeworks/devops-netology\04-script-02-py/show_git_mod.py

```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:

```python
#!/usr/bin/env python3

import os
import argparse

parser = argparse.ArgumentParser(description='list git modifies, deleted, untracked files')
parser.add_argument('repo', type=str, default=os.getcwd(), help='git repo directory')
args = parser.parse_args()

bash_command = [f"cd {args.repo}", "git ls-files -dmo"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.splitlines():
    print(os.path.join(args.repo, result.strip()))

```

### Вывод скрипта при запуске при тестировании:
```
$ python 04-script-02-py/show_git_mod_arg.py $(pwd)
C:\Users\Askbow\PycharmProjects\sysadm-homeworks\devops-netology\04-script-02-py/README.md
C:\Users\Askbow\PycharmProjects\sysadm-homeworks\devops-netology\04-script-02-py/show_git_mod.py
C:\Users\Askbow\PycharmProjects\sysadm-homeworks\devops-netology\04-script-02-py/show_git_mod_arg.py

```



## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import sys
import socket
import json


DATASTORE="service_dns_record.json"
CONFIG="service.conf"


def get_historical_data():
    try:
        with open(DATASTORE, 'r') as file:
            data = json.load(file)
    except FileNotFoundError:
        data = dict()
    return data


def put_historical_data(data):
    with open(DATASTORE, 'w+') as file:
        json.dump(data, file, indent=4)


def read_config():
    try:
        with open(CONFIG, 'r') as file:
            return file.readlines()
    except FileNotFoundError:
        print(f"ERROR: config file {CONFIG} not found")
        sys.exit(1)


def check_dns(services, data):
    for service in services:
        service = service.strip()
        new_ip = socket.gethostbyname(service)
        old_ip = data.get(service)
        if old_ip is None:
            pass
        elif not old_ip == new_ip:
            print(f'[ERROR] {service} IP mismatch: {old_ip} {new_ip}')
        data[service] = new_ip
    return data


def print_data(data):
    for service, ip in data.items():
        print(f'{service} - {ip}')


def main():
    services = read_config()
    data = get_historical_data()
    data = check_dns(services, data)
    print_data(data)
    put_historical_data(data)


if __name__ == "__main__":
    main()
```

### Вывод скрипта при запуске при тестировании:
```
$ python service_dns_test.py
[ERROR] drive.google.com IP mismatch: 1.1.1.1 142.251.37.110
[ERROR] mail.google.com IP mismatch: 4.4.4.4 142.251.36.133
[ERROR] google.com IP mismatch: 8.8.8.8 142.251.36.142
drive.google.com - 142.251.37.110
mail.google.com - 142.251.36.133
google.com - 142.251.36.142

$ python service_dns_test.py
drive.google.com - 142.251.37.110
mail.google.com - 142.251.36.133
google.com - 142.251.36.142

```
