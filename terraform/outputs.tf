# -----------------------------------
# S3 Bucket Name
# -----------------------------------

output "s3_bucket_name" {
  description = "Name of the S3 bucket used for data upload"
  value       = aws_s3_bucket.data_bucket.bucket
}

# -----------------------------------
# Processor Lambda Name
# -----------------------------------

output "processor_lambda_name" {
  description = "Name of the CSV processor Lambda function"
  value       = aws_lambda_function.processor_lambda.function_name
}

# -----------------------------------
# Reporter Lambda Name
# -----------------------------------

output "reporter_lambda_name" {
  description = "Name of the daily reporter Lambda function"
  value       = aws_lambda_function.reporter_lambda.function_name
}

# -----------------------------------
# Scheduler Rule Name
# -----------------------------------

output "daily_scheduler_rule" {
  description = "CloudWatch rule that triggers daily report"
  value       = aws_cloudwatch_event_rule.daily_report_rule.name
}
