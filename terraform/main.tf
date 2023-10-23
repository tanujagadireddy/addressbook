terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
  backend "s3" {
        bucket="tf-new-1"
        key="terraform.tfstate"
        region="ap-south-1"
        dynamodb_table="tf-table-1"
    }
}
provider "aws" {
  # Configuration options
    access_key = "AKIAYMMUQNNLZLS6RUM7"
    secret_key = "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"
    region     = "ap-south-1"
  
}

resource "aws_vpc" "ownvpc" {
  #cidr_block = "10.0.0.0/16"
  cidr_block = var.vpc_cidr_block
  tags={
    Name="own-vpc"
  }
}

module "myown-subnet"{
  source ="./modules/subnet"
  vpc_id=aws_vpc.ownvpc.id
  subnet_cidr_block = var.subnet_cidr_block
  az=var.az
  env=var.env
}

module "myown-instance"{
  source = "./modules/webserver"
  vpc_id=aws_vpc.ownvpc.id
  subnet_id = module.myown-subnet.subnet.id
  env=var.env
  instance_type = var.instance_type

}