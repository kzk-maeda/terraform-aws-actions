terraform {
  backend "s3" {
    bucket = "terraform-tfstate"
    key    = ".tfstate/services/aws-action"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  version = "~>3.0"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
