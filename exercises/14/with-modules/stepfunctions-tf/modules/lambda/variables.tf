variable "region" {
  default = "us-west-2"
  type    = string
}

variable "lambda_source_path" {
  type    = string
  description = "Path to the lambda source code"  
}

variable "lambda_output_path" {
  type    = string
  description = "Path lambda zip output should be stored"  
}

variable "function_name_prefix" {
  type    = string
  description = "Prefix for the function name"  
}

variable "function_role_arn" {
  type    = string
  description = "ARN of the role to attach to the function"  
}

variable "lambda_handler_name" {
  type    = string
  description = "Name of the lambda handler function"  
}

variable "lambda_function_runtime" {
  type    = string
  description = "Runtime for the lambda function"  
}

