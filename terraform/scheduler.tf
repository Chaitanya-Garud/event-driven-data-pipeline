# -----------------------------------
# CloudWatch Event Rule (Daily Schedule)
# -----------------------------------

resource "aws_cloudwatch_event_rule" "daily_report_rule" {
  name                = "${var.environment}-daily-report-rule"
  description         = "Triggers reporter lambda daily"
  schedule_expression = "cron(0 8 * * ? *)" # Runs daily at 8 AM UTC

  tags = {
    Environment = var.environment
  }
}

# -----------------------------------
# Connect Rule to Reporter Lambda
# -----------------------------------

resource "aws_cloudwatch_event_target" "report_lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_report_rule.name
  target_id = "ReportLambdaTarget"
  arn       = aws_lambda_function.reporter_lambda.arn
}

# -----------------------------------
# Allow CloudWatch to Invoke Lambda
# -----------------------------------

resource "aws_lambda_permission" "allow_cloudwatch_invoke" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reporter_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_report_rule.arn
}
