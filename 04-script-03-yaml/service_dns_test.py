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