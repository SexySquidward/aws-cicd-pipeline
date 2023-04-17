terraform {
  backend "s3" {
    bucket = "aws-codepipeline-testing123452434"
    encrypt = true
    key = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}
provider "aws" {
  region = "ap-southeast-2"
}