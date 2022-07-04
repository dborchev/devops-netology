provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent      = true
  name_regex       = "^ubuntu/images/hvm-ssd/ubuntu-jammy-.+"
  owners = ["099720109477"] # Canonical https://ubuntu.com/server/docs/cloud-images/amazon-ec2

  filter {
        name   = "virtualization-type"
        values = ["hvm"]
  }
}
