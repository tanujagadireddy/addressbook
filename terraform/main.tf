terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.1"
    }
  }
  # backend "s3"{
  #   bucket="tf-backend-sample"
  #   key="terraform.tfstate"
  #   region="ap-south-1"
  #   dynamodb_table = "tf-infra"
  # }
}

provider "aws" {
  # Configuration options
   region     = "ap-south-1"
#   access_key = "my-access-key"
#   secret_key = "my-secret-key"
}

# variable "instance_type"{}

# craete the vpc

resource "aws_vpc" "ownvpc" {
  cidr_block = var.vpc_cidr_block
  tags={
    Name="own-vpc"
  }
}

module "myown-subnet" {
  source = "./modules/subnet"
  vpc_id = aws_vpc.ownvpc.id
  subnet_cidr_block = var.subnet_cidr_block

}

module "myown-webserver"{
  source ="./modules/webserver"
  vpc_id = aws_vpc.ownvpc.id
  subnet_id = module.myown-subnet.subnet.id
  instance_type = var.instance_type
}