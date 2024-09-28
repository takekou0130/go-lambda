# terraformでは箱だけ作り、AWSコンソールから値を入れる
# workload_identityだったらただのstringでOK
resource "aws_ssm_parameter" "gcp_key" {
  name  = "/go-lambda/gcp-key"
  type  = "String"
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}
