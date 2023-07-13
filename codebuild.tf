locals {
  repolist = join(",", [for k, repo in var.containers : join(",", [for tag in repo : "${k}:${tag}"])])
}

module "build" {
  source             = "cloudposse/codebuild/aws"
  version            = "1.0.0"
  namespace          = "eg"
  stage              = "staging"
  name               = "app"
  build_image        = "aws/codebuild/standard:7.0"
  build_compute_type = "BUILD_GENERAL1_SMALL"
  build_timeout      = 60
  build_type         = "LINUX_CONTAINER"
  source_type        = "NO_SOURCE"
  artifact_type      = "NO_ARTIFACTS"
  artifact_location  = null
  privileged_mode    = true
  buildspec          = file("buildspec.yml")
  environment_variables = [
    {
      name  = "REPOLIST"
      value = local.repolist
      type  = "PLAINTEXT"
    },
    {
      name  = "NAMESPACE"
      value = var.namespace
      type  = "PLAINTEXT"
    },
    {
      name  = "DOCKERHUB_USERNAME",
      value = var.docker_hub_username,
      type  = "PLAINTEXT"
    },
    {
      name  = "DOCKERHUB_TOKEN",
      value = aws_ssm_parameter.accesstoken.name,
      type  = "PARAMETER_STORE"
    }
  ]
}