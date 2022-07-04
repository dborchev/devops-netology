# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

https://github.com/netology-code/virt-homeworks/blob/virt-11/07-terraform-02-syntax/README.md

## Задача 1 (вариант с AWS). Регистрация в aws и знакомство с основами 

1. Создайте аккаут aws.✅
2. Установите c aws-cli https://aws.amazon.com/cli/. ✅
3. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html. ✅
4. Создайте IAM политику для терраформа ✅
5. Добавьте переменные окружения ✅
6. Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс. ✅

>В виде результата задания приложите вывод команды `aws configure list`.

```bash
$ aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************IOM7              env
secret_key     ****************XY0R              env
    region                eu-west-1      config-file    ~/.aws/config
```


## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ.

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
   1. https://github.com/dborchev/devops-netology/blob/main/teraform/main.tf
   2. https://github.com/dborchev/devops-netology/blob/main/teraform/versions.tf
2. Зарегистрируйте провайдер ✅ 
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения.👍
   1. в репозиторий нет, но принципиально секреты хранить в гитхабе можно https://docs.github.com/en/actions/security-guides/encrypted-secrets
   2. и с ними можно даже как-то работать из тераформа https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret
   3. но тогда где-то нужно также хранить ключи от гитхаба с правами на запись, что может быть еще хуже
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu. 
   1. https://github.com/dborchev/devops-netology/commit/c6af57ec4d28e53a76046f64ad3d673f124d9e7a
5. В файле `main.tf` создайте рессурс [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
   Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
   `Example Usage`, но желательно, указать большее количество параметров.
   1. https://github.com/dborchev/devops-netology/commit/3cdd299b92dc866dda1b137a9dc147b20a6fa254
6. Также в случае использования aws:
   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`. ✅
   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
       * AWS account ID, ✅
       * AWS user ID,✅
       * AWS регион, который используется в данный момент, ✅
       * Приватный IP ec2 инстансы,✅
       * Идентификатор подсети в которой создан инстанс.✅
   3. https://github.com/dborchev/devops-netology/commit/1d560f7722227fd53b058d57e51ed5beafc3e409
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 
<details>
  <summary>Успешный вывод `terraform plan`</summary>

```bash
~/devops-netology/teraform$ terraform plan
data.aws_caller_identity.current: Reading...
data.aws_region.current: Reading...
data.aws_ami.ubuntu: Reading...
data.aws_region.current: Read complete after 0s [id=eu-west-1]
data.aws_caller_identity.current: Read complete after 0s [id=476508053190]
data.aws_ami.ubuntu: Read complete after 4s [id=ami-08ff82115239305ce]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.netology will be created
  + resource "aws_instance" "netology" {
      + ami                                  = "ami-08ff82115239305ce"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = "eu-west-1a"
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = false
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name"    = "07-terraform-02-syntax"
          + "project" = "netology"
        }
      + tags_all                             = {
          + "Name"    = "07-terraform-02-syntax"
          + "project" = "netology"
        }
      + tenancy                              = (known after apply)
      + user_data                            = "4a416eabd71551e57fe446337e4305648b922e0f"
      + user_data_base64                     = (known after apply)
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id = (known after apply)
            }
        }

      + credit_specification {
          + cpu_credits = "unlimited"
        }

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
          + instance_metadata_tags      = (known after apply)
        }

      + network_interface {
          + delete_on_termination = false
          + device_index          = 0
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_network_interface.netology_interface will be created
  + resource "aws_network_interface" "netology_interface" {
      + arn                       = (known after apply)
      + id                        = (known after apply)
      + interface_type            = (known after apply)
      + ipv4_prefix_count         = (known after apply)
      + ipv4_prefixes             = (known after apply)
      + ipv6_address_count        = (known after apply)
      + ipv6_address_list         = (known after apply)
      + ipv6_address_list_enabled = false
      + ipv6_addresses            = (known after apply)
      + ipv6_prefix_count         = (known after apply)
      + ipv6_prefixes             = (known after apply)
      + mac_address               = (known after apply)
      + outpost_arn               = (known after apply)
      + owner_id                  = (known after apply)
      + private_dns_name          = (known after apply)
      + private_ip                = (known after apply)
      + private_ip_list           = (known after apply)
      + private_ip_list_enabled   = false
      + private_ips               = [
          + "172.16.10.100",
        ]
      + private_ips_count         = (known after apply)
      + security_groups           = (known after apply)
      + source_dest_check         = true
      + subnet_id                 = (known after apply)
      + tags                      = {
          + "Name" = "primary_network_interface"
        }
      + tags_all                  = {
          + "Name" = "primary_network_interface"
        }

      + attachment {
          + attachment_id = (known after apply)
          + device_index  = (known after apply)
          + instance      = (known after apply)
        }
    }

  # aws_subnet.netology_subnet will be created
  + resource "aws_subnet" "netology_subnet" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "eu-west-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "172.16.10.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name"    = "tf-example"
          + "project" = "netology"
        }
      + tags_all                                       = {
          + "Name"    = "tf-example"
          + "project" = "netology"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.netology_vpc will be created
  + resource "aws_vpc" "netology_vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "172.16.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name"    = "tf-example"
          + "project" = "netology"
        }
      + tags_all                             = {
          + "Name"    = "tf-example"
          + "project" = "netology"
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + account_id = "*********3190"
  + private_ip = (known after apply)
  + region     = "eu-west-1"
  + subnet_id  = (known after apply)
  + user_id    = "***************N42I"

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
"terraform apply" now.
```

</details>


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
   1. создавать AMI можно с помощью packer: https://www.packer.io/plugins/builders/amazon
2. Ссылку на репозиторий с исходной конфигурацией терраформа.
   1. https://github.com/dborchev/devops-netology/blob/main/teraform/main.tf
   2. https://github.com/dborchev/devops-netology/blob/main/teraform/versions.tf
