# terraformでは箱だけ作り、AWSコンソールから値を入れる
resource "aws_ssm_parameter" "gcp_key" {
  name  = "/go-lambda/gcp-key"
  type  = "SecureString"
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}
