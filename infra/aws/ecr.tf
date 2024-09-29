resource "aws_ecr_repository" "go_lambda" {
  name                 = "takekou-go-lambda"
  image_tag_mutability = "IMMUTABLE"
}
