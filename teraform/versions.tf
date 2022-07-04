terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "user_id" {
  value = data.aws_caller_identity.current.user_id
}

output "region" {
  value = data.aws_region.current.name
}

output "private_ip" {
  value = aws_instance.netology.private_ip
}

output "subnet_id" {
  value = aws_subnet.netology_subnet.id
}
