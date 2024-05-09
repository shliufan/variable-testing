terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
}

variable "vpc_singapore_cidr" {
    type    = string
}

variable "vpc_virginia_cidr" {
    type    = string
}

variable "instance_type_singapore" {
  type    = string
}

variable "instance_type_virginia" {
    type    = string
}

variable "key_name_singapore" {
    type    = string
}

variable "key_name_virginia" {
    type    = string
}

variable "ami_id_singapore" {
    type    = string
}

variable "ami_id_virginia" {
    type    = string
}

resource "aws_vpc" "vpc_singapore" {
    provider = aws.dev-singapore
    cidr_block = var.vpc_singapore_cidr
    tags = {
        Name = "vpc_singapore"
    }
}

resource "aws_subnet" "vpc_subnet_singapore" {
  provider = aws.dev-singapore
    vpc_id = aws_vpc.vpc_singapore.id
    cidr_block = var.vpc_singapore_cidr
}

resource "aws_route_table_association" "subnet_table_association" {
  provider = aws.dev-singapore
  subnet_id = aws_subnet.vpc_subnet_singapore.id
  route_table_id = aws_vpc.vpc_singapore.default_route_table_id
}

resource "aws_internet_gateway" "vpc_internet_gateway" {
  provider = aws.dev-singapore
  vpc_id = aws_vpc.vpc_singapore.id
}

resource "aws_route" "route_1_singapore" {
  provider = aws.dev-singapore
  route_table_id = aws_vpc.vpc_singapore.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_internet_gateway.id
}

resource "aws_route" "route-2-singapore" {
  provider               = aws.dev-singapore
  route_table_id         = aws_vpc.vpc_singapore.default_route_table_id
  destination_cidr_block = "10.1.0.0/16"
  gateway_id             = aws_ec2_transit_gateway.tgw-singapore.id
}

resource "aws_instance" "ec2_instance_singapore" {
  provider = aws.dev-singapore
  subnet_id = aws_subnet.vpc_subnet_singapore.id
    ami           = var.ami_id_singapore
    instance_type = var.instance_type_singapore
    key_name      = var.key_name_singapore
  associate_public_ip_address = true
    tags = {
        Name = "ec2_singapore"
    }
}

resource "aws_vpc" "vpc_virginia" {
  provider   = aws.dev-virginia
  cidr_block = var.vpc_virginia_cidr
  tags       = {
    Name = "vpc_virginia"
  }
}

resource "aws_subnet" "vpc_subnet_virginia" {
  provider = aws.dev-virginia
  vpc_id = aws_vpc.vpc_virginia.id
  cidr_block = var.vpc_virginia_cidr
}

resource "aws_route_table_association" "route_table_association" {
  provider = aws.dev-virginia
  subnet_id      = aws_subnet.vpc_subnet_virginia.id
  route_table_id = aws_vpc.vpc_virginia.default_route_table_id
}

resource "aws_internet_gateway" "vpc_internet_gateway_virginia" {
  provider = aws.dev-virginia
  vpc_id = aws_vpc.vpc_virginia.id
}

resource "aws_route" "route_1_virginia" {
  provider = aws.dev-virginia
  route_table_id         = aws_vpc.vpc_virginia.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.vpc_internet_gateway_virginia.id
}

resource "aws_route" "route-2-virginia" {
    provider = aws.dev-virginia
    route_table_id         = aws_vpc.vpc_virginia.default_route_table_id
    destination_cidr_block = "10.0.0.0/16"
  gateway_id = aws_ec2_transit_gateway.tgw-virginia.id
}

resource "aws_instance" "ec2_instance_virginia" {
  provider = aws.dev-virginia
  subnet_id = aws_subnet.vpc_subnet_virginia.id
    ami           = var.ami_id_virginia
    instance_type = var.instance_type_virginia
    key_name      = var.key_name_virginia
  associate_public_ip_address = true
    tags = {
        Name = "ec2_virginia"
    }
}



