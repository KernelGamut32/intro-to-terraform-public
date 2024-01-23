terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0.0"
    }
  }
}

provider "aws" {
    region = "<your region here>"
}

resource "aws_s3_bucket" "lab13" {
    bucket = "<your unique bucket name here>"
}

resource "aws_s3_bucket_public_access_block" "lab13" {
  bucket = aws_s3_bucket.lab13.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "lab13" {
  bucket = aws_s3_bucket.lab13.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lab13" {
  bucket = aws_s3_bucket.lab13.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }

    bucket_key_enabled = true
  }
}
