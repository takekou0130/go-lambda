terraform {
  backend "s3" {
    bucket = "takekou-go-lambda-tfstate"
    key    = "tfstate"
    region = "ap-northeast-1"
    # need for state lock
    # dynamodb_table = "xxx"
  }
}
