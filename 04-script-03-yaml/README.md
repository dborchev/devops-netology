# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

https://github.com/netology-code/sysadm-homeworks/blob/devsys10/04-script-03-yaml/README.md

## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис.
  

```json
{
    "info": "Sample JSON output from our service\t",
    "elements": [
        {
            "name": "first",
            "type": "server",
            "ip": 7175
        },
        {
            "name": "second",
            "type": "proxy",
            "ip": "71.78.22.43"
        }
    ]
}
```
+ хотя 7175 не выглядит как IPv4-адрес, любой IP-адрес -- это просто целое число:
```python
In [8]: ipaddress.ip_address(7175)
Out[8]: IPv4Address('0.0.28.7')
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import sys
import socket
import json
import yaml


DATASTORE = "service_dns_record.json"
CONFIG = "service.conf"
DUMP_JSON = "dump.json"
DUMP_YAML = "dump.yaml"


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


def dump_data(data):
    dump = [
        {service: ip}
        for service, ip in data.items()
    ]
    with open(DUMP_JSON, 'w+') as file:
        json.dump(dump, file)
    with open(DUMP_YAML, 'w+') as file:
        yaml.dump(dump, file)


def main():
    services = read_config()
    data = get_historical_data()
    data = check_dns(services, data)
    print_data(data)
    dump_data(data)
    put_historical_data(data)


if __name__ == "__main__":
    main()
```

### Вывод скрипта при запуске при тестировании:
```bash
 python .\service_dns_test.py
[ERROR] drive.google.com IP mismatch: 1.1.1.1 142.251.36.142
[ERROR] mail.google.com IP mismatch: 1.1.1.1 142.251.36.133
[ERROR] google.com IP mismatch: 1.1.1.1 142.251.36.110
drive.google.com - 142.251.36.142
mail.google.com - 142.251.36.133
google.com - 142.251.36.110
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
[{"drive.google.com": "142.251.36.142"}, {"mail.google.com": "142.251.36.133"}, {"google.com": "142.251.36.110"}]
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
- drive.google.com: 142.251.36.142
- mail.google.com: 142.251.36.133
- google.com: 142.251.36.110
```