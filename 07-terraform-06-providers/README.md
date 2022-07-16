# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

https://github.com/netology-code/virt-homeworks/blob/virt-11/07-terraform-06-providers/README.md

>Бывает, что 
>* общедоступная документация по терраформ ресурсам не всегда достоверна,
>* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
>* понадобиться использовать провайдер без официальной документации,
>* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе. 
   1. `data_source` определны в `DataSourcesMap`: https://github.com/dborchev/terraform-provider-aws/blob/main/internal/provider/provider.go#L412-L906
   2. `resource` определены в `ResourcesMap`: https://github.com/dborchev/terraform-provider-aws/blob/main/internal/provider/provider.go#L908-L2091
1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
      * с параметром `name_prefix`, который создает ресурсу уникальное имя с заданным префиксом, тогда как `name` позволяет задать конкретное имя
      * https://github.com/dborchev/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L87
    * Какая максимальная длина имени? 
      * 80 символов
      * ограничено в регулярном выражении (см. ниже)
      * также, документация AWS: [https://aws.amazon.com/sqs/faqs/](https://aws.amazon.com/sqs/faqs/#:~:text=Q%3A%20Is%20there%20a%20size,are%20limited%20to%2080%20characters.)
    * Какому регулярному выражению должно подчиняться имя? 
      * для FIFO-очередей `^[a-zA-Z0-9_-]{1,75}\.fifo$`: https://github.com/dborchev/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L425
      * для обычных очередей `^[a-zA-Z0-9_-]{1,80}$`: https://github.com/dborchev/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L427
