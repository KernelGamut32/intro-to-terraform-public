# variables.tf

# Declare a variable so we can use it.
variable "region" {
  default = "us-west-2"
  type    = string
}

variable "student_name" {
  default = "student-"
  type    = string
}

output "bucket_name" {
  value = aws_s3_bucket.user_bucket.bucket
}
