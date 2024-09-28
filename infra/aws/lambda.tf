resource "aws_lambda_function" "go_lambda" {
  function_name = "takekou-go-lambda"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.go_lambda.repository_url}:latest"
  role          = aws_iam_role.lambda.arn
  publish       = true
  architectures = ["arm64"]
  # つけてはいけない
  #   runtime       = "provided.al2023"
  timeout = 10

  environment {
    variables = {
      ENV = "aaa"
    }
  }

  image_config {
    entry_point = ["/functions/version"]
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

# 必要かも?
resource "aws_lambda_function_event_invoke_config" "go_lambda" {
  function_name          = aws_lambda_function.go_lambda.function_name
  maximum_retry_attempts = 0
}

resource "aws_cloudwatch_log_group" "go_lambda" {
  name              = "/aws/lambda/${aws_lambda_function.go_lambda.function_name}"
  retention_in_days = 3
}
