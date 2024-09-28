resource "aws_iam_role" "lambda" {
  name               = "takekou-go-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "basic_execution_role" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# for get ssm
resource "aws_iam_role_policy_attachment" "access_to_ssm" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.access_to_ssm.arn
}

resource "aws_iam_policy" "access_to_ssm" {
  name   = "access-to-gcp-key"
  policy = data.aws_iam_policy_document.access_to_ssm.json
}

data "aws_iam_policy_document" "access_to_ssm" {
  statement {
    actions   = ["ssm:GetParameter"]
    resources = [aws_ssm_parameter.gcp_key.arn]
  }
}
