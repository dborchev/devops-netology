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

resource "aws_instance" "netology" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = False
  availability_zone = "eu-west-1a"
  ipv6_address_count = "4"
  source_dest_check = False
  monitoring = False

  user_data = "apt-get -y update && apt-get -y install nginx"

  tags = {
    Name = "07-terraform-02-syntax"
    project = "netology"
  }
}
