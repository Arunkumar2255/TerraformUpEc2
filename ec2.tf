terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
} 


provider "aws" {
  region     = "us-west-2"
  access_key = "AKIAVPAYF53G36C5PDFY"
  secret_key = "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"
}

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {}

resource "aws_key_pair" "key_pair" {
  key_name   = "var.key_name"
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  content = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

resource "aws_instance" "s1" {
  ami           = "ami-09ac7e749b0a8d2a1"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name
  tags = {
    Name = "server1"
}
}

resource "aws_instance" "s2" {
 ami           = "ami-09ac7e749b0a8d2a1"
 instance_type = "t2.micro"
 key_name      = aws_key_pair.key_pair.key_name

 tags = {
   Name = "server2"
}
}


