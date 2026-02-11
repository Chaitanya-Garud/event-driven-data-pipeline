# -----------------------------------
# Processor Lambda Function
# -----------------------------------

resource "aws_lambda_function" "processor_lambda" {
  function_name = var.processor_lambda_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename         = "../lambda/processor.zip"
  source_code_hash = filebase64sha256("../lambda/processor.zip")

  timeout = 10

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }

  tags = {
    Environment = var.environment
  }
}

# -----------------------------------
# Reporter Lambda Function
# -----------------------------------

resource "aws_lambda_function" "reporter_lambda" {
  function_name = var.reporter_lambda_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename         = "../lambda/reporter.zip"
  source_code_hash = filebase64sha256("../lambda/reporter.zip")

  timeout = 10

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }

  tags = {
    Environment = var.environment
  }
}

# -----------------------------------
# Allow S3 to Invoke Processor Lambda
# -----------------------------------

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_bucket.arn
}

# -----------------------------------
# S3 Event Notification
# -----------------------------------

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.data_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3_invoke
  ]
}
