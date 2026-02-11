variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "processor_lambda_name" {
  description = "Lambda function name for processor"
  type        = string
}

variable "reporter_lambda_name" {
  description = "Lambda function name for reporter"
  type        = string
}
