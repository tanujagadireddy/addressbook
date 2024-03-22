terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.41.0"
    }
  }

  # backend s3 {
  #   bucket="my-tf-remote"
  #   key="terraform.tfstate"
  #   region = "ap-south-1"
  #   dynamodb_table = "tf-table-final"
  # }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
  #   access_key = "my-access-key"
  #   secret_key = "my-secret-key"
}



resource "aws_vpc" "ownvpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env}-vpc"
  }

}

module "mysubnet" {
  source            = "./modules/subnet"
  vpc_id            = aws_vpc.ownvpc.id
  subnet_cidr_block = var.subnet_cidr_block
  az                = var.az
  env               = var.env
}

module "myec2" {
  source        = "./modules/webserver"
  vpc_id        = aws_vpc.ownvpc.id
  subnet_id     = module.mysubnet.subnet.id
  env           = var.env
  instance_type = var.instance_type
}