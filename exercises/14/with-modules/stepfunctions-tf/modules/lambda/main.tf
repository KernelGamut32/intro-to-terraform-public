terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0.0"
    }
  }
}

# Declare the provider being used, in this case it's AWS.
# Provider supports setting things like target region.
# It can also pull credentials and the region to use from environment variables, which we have set, so we'll use those
provider "aws" {
  region = var.region
}

resource "random_string" "random" {
  length  = 4
  special = false
}

data "archive_file" "lambda_source" {
  type        = "zip"
  source_file = var.lambda_source_path
  output_path = var.lambda_output_path
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = "${var.function_name_prefix}-${random_string.random.id}"
  role             = var.function_role_arn
  handler          = var.lambda_handler_name
  runtime          = var.lambda_function_runtime
  filename         = var.lambda_output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
}

resource "aws_cloudwatch_log_group" "lambda_function_log" {
  retention_in_days = 1
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
}
