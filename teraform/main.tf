provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "ubuntu" {
  most_recent      = true
  name_regex       = "^ubuntu/images/hvm-ssd/ubuntu-jammy-.+"
  owners = ["099720109477"] # Canonical https://ubuntu.com/server/docs/cloud-images/amazon-ec2

  filter {
        name   = "virtualization-type"
        values = ["hvm"]
  }
}

resource "aws_vpc" "netology_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
    project = "netology"
  }
}

resource "aws_subnet" "netology_subnet" {
  vpc_id            = aws_vpc.netology_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "tf-example"
    project = "netology"
  }
}

resource "aws_network_interface" "netology_interface" {
  subnet_id   = aws_subnet.netology_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}



resource "aws_instance" "netology" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  availability_zone = "eu-west-1a"
  monitoring = False

  user_data = "apt-get -y update && apt-get -y install nginx"

  network_interface = {
    network_interface_id = aws_network_interface.netology_interface.id
    device_index = 0
  }

  credit_specification = {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "07-terraform-02-syntax"
    project = "netology"
  }
}
