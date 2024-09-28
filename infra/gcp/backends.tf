terraform {
  backend "gcs" {
    bucket = "takekou-go-lambda-tfstate"
    prefix = "go-lambda-tfstate"
  }
}
