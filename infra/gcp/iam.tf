resource "google_service_account" "gcs_access" {
  account_id   = "gcs-access"
  display_name = "gcs-access"
  project      = var.project_id
  description  = "used by AWS lambda to allow access to GCS"
}

resource "google_storage_bucket_iam_member" "gcs_access" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.gcs_access.email}"
}
