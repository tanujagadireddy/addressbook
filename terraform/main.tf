terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.25.0"
    }
  }

  # backend "s3" {
  #       bucket="tf-b1"
  #       key="terraform.tfstate"
  #       region="ap-south-1"
  #       dynamodb_table="tf-aws"
  #   }

}

provider "aws" {
  region = "ap-south-1"
#    access_key = "xxxx"
#  secret_key = "xxxxxx"

}

resource "aws_vpc" "ownvpc" {
  cidr_block = var.vpc_cidr_block
    tags = {
    Name = "${var.env}-vpc"
  }
}

module "myserver-subnet"{
  source="./modules/subnet"
  vpc_id=aws_vpc.ownvpc.id
  subnet_cidr_block = var.subnet_cidr_block
  env=var.env
  az=var.az
}

module "myserver-ec2"{
  source="./modules/webserver"
  vpc_id=aws_vpc.ownvpc.id
  subnet_id=module.myserver-subnet.subnet.id
  env=var.env
  instance_type = var.instance_type
}