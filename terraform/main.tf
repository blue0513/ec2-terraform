variable "allow_ip" {
  default = ["0.0.0.0/0"]
}

variable "ami" {
  default = "ami-08347baaec0755352" # ubuntu 20.04
}

variable "instance_type" {
  default = "t3.nano"
}
locals {
  my_pub_key = "../ssh-keys/my-ssh-key.pub"
}

provider "aws" {
  region = "ap-northeast-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "server-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["ap-northeast-1a"]
  public_subnets = ["10.0.11.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "server_sg" {
  name   = "server_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
  ami                    = var.ami
  key_name               = aws_key_pair.ssh_pub_key.key_name
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.server_sg.id]

  tags = {
    Name = "server"
  }
}

resource "aws_key_pair" "ssh_pub_key" {
  key_name = "server_pub_key"
  # Locate your public key
  public_key = file(local.my_pub_key)
}
