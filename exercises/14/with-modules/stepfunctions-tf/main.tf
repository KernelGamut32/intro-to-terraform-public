terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "random" {}

resource "random_string" "random" {
  length  = 4
  special = false
}

resource "aws_iam_role" "function_role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action : "sts:AssumeRole"
        Effect : "Allow"
        Sid : ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
}

module "descision_function" {
  source                  = "./modules/lambda/"
  region                  = "${var.region}"
  lambda_source_path      = "./src/lambda.py"
  lambda_output_path      = "./src/lambda.zip"
  function_name_prefix    = "HelloFunction"
  function_role_arn       = aws_iam_role.function_role.arn
  lambda_handler_name     = "lambda.lambda_handler"
  lambda_function_runtime = "python3.9"
}

module "true_route_function" {
  source                  = "./modules/lambda/"
  region                  = "${var.region}"
  lambda_source_path      = "./src/true-route.py"
  lambda_output_path      = "./src/true-route.zip"
  function_name_prefix    = "TrueRouteFunction"
  function_role_arn       = aws_iam_role.function_role.arn
  lambda_handler_name     = "true-route.lambda_handler"
  lambda_function_runtime = "python3.9"
}

module "false_route_function" {
  source                  = "./modules/lambda/"
  region                  = "${var.region}"
  lambda_source_path      = "./src/false-route.py"
  lambda_output_path      = "./src/false-route.zip"
  function_name_prefix    = "FalseRouteFunction"
  function_role_arn       = aws_iam_role.function_role.arn
  lambda_handler_name     = "false-route.lambda_handler"
  lambda_function_runtime = "python3.9"
}

# Create an IAM role for the Step Functions state machine
resource "aws_iam_role" "StateMachineRole" {
  name               = "StepFunctions-Terraform-Role-${random_string.random.id}"
  assume_role_policy = <<Role1
{
"Version" : "2012-10-17",
"Statement" : [
    {
    "Effect" : "Allow",
    "Principal" : {
        "Service" : "states.amazonaws.com"
    },
    "Action" : "sts:AssumeRole"
    }
]
}
Role1
}

# Create an IAM policy for the Step Functions state machine
resource "aws_iam_role_policy" "StateMachinePolicy" {
  role   = aws_iam_role.StateMachineRole.id
  policy = <<POLICY1
{
"Version" : "2012-10-17",
"Statement" : [
    {
    "Effect" : "Allow",
    "Action" : [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogDelivery",
        "logs:GetLogDelivery",
        "logs:UpdateLogDelivery",
        "logs:DeleteLogDelivery",
        "logs:ListLogDeliveries",
        "logs:PutResourcePolicy",
        "logs:DescribeResourcePolicies",
        "logs:DescribeLogGroups",
        "cloudwatch:PutMetricData",
        "lambda:InvokeFunction"
    ],
    "Resource" : "*"
    }
]
}
POLICY1
}

# State machine definition file with the variables to replace
data "template_file" "SFDefinitionFile" {
  template = file("statemachines/statemachine.asl.json")
  vars = {
    DecisionFunction = module.descision_function.lambda_function_arn
    TrueFunction     = module.true_route_function.lambda_function_arn
    FalseFunction    = module.false_route_function.lambda_function_arn
  }
}

# Create the AWS Step Functions state machine
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name_prefix = "MyStateMachineViaTerraform-${random_string.random.id}"
  role_arn    = aws_iam_role.StateMachineRole.arn
  definition  = data.template_file.SFDefinitionFile.rendered
  type        = "STANDARD"
}
