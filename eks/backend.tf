terraform {
required_version = "~> 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
  }
  backend "s3" {
    bucket         = "s3statebackendwacim12437"
    region         = "us-east-1"
    key            = "global/mystatefile/terraform.tfstate"
    dynamodb_table = "state-lock"
    encrypt        = true
  }
}
resource "aws_s3_bucket" "mybucket" {
  bucket = "s3statebackendwacim12437"
  versioning {
  enabled = true
  }
server_side_encryption_configuration {
rule {
  apply_server_side_encryption_by_default {
  sse_algorithm = "AES256"
        }
      }
    }
}
#create dynamodb
resource "aws_dynamodb_table" "statelock"{
name = "state-lock"
billing_mode = "PAY_PER_REQUEST"
hash_key = "LockID"

attribute {
  name = "LockID"
  type = "S"
  }
}
provider "aws" {
  region  = var.aws-region
}
