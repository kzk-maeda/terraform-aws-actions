terraform {
  backend "s3" {
    bucket                  = "kzk-sandbox-terraform-tfstate"
    key                     = ".tfstate/services/aws-action"
    region                  = "ap-northeast-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "aws-actions-terraform"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  version = "~>3.0"
  profile = "aws-actions-terraform"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
