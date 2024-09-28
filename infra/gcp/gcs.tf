resource "google_storage_bucket" "bucket" {
  name          = "takekou-go-lambda-access"
  location      = "asia-northeast1"
  storage_class = "STANDARD"
}
