resource "aws_ssm_parameter" "accesstoken" {
  name  = "${var.prefix}docker"
  type  = "SecureString"
  value = var.docker_hub_access_token
}