resource "google_iam_workload_identity_pool" "aws" {
  workload_identity_pool_id = "aws-for-go-lambda"
}

resource "google_iam_workload_identity_pool_provider" "aws" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.aws.workload_identity_pool_id
  workload_identity_pool_provider_id = "aws-for-go-lambda"
  attribute_mapping = {
    "google.subject"        = "assertion.arn"
    "attribute.aws_role"    = "assertion.arn.extract('assumed-role/{role}/')"
    "attribute.aws_session" = "assertion.arn.extract('assumed-role/{role_and_session}').extract('/{session}')"
  }
  aws {
    account_id = var.aws_account_id
  }
}

resource "google_service_account_iam_member" "workload_identity_for_aws" {
  service_account_id = google_service_account.gcs_access.name
  role               = "roles/iam.workloadIdentityUser"
  # role-nameの部分は変数化してもいいかも
  member = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.aws.workload_identity_pool_id}/attribute.aws_role/takekou-go-lambda"
}

data "google_project" "project" {
  project_id = var.project_id
}

# workload_identity使おうとしたらこんなエラーになったので必要
# "IAM Service Account Credentials API has not been used in project xxx before or it is disabled.
# Enable it by visiting https://console.developers.google.com/apis/api/iamcredentials.googleapis.com/overview?project=xxx then retry.
# If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.
resource "google_project_service" "enable_iam_credentials" {
  project = var.project_id
  service = "iamcredentials.googleapis.com"
}
