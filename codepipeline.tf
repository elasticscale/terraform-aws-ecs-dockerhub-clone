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
      name  = "JENKINS_URL"
      value = "https://jenkins.example.com"
      type  = "PLAINTEXT"
    },
    {
      name  = "COMPANY_NAME"
      value = "Amazon"
      type  = "PLAINTEXT"
    },
    {
      name  = "TIME_ZONE"
      value = "Pacific/Auckland"
      type  = "PLAINTEXT"
    }
  ]
}