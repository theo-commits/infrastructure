# Terraform configuration

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_state_test" {
  # Unique bucket name 
  bucket = "projectreclass-test-bucket"

  # Prevent accidental deletion of tf state
  lifecycle {
    prevent_destroy = false 
  }

  # Enable Versioning to track history 
  versioning {
    enabled = true
  }

  # Enable Encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "db_for_tf_locks_test" {
  name           = "db_for_tf_locks_test"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
