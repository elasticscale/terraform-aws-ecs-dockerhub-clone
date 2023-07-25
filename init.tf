
data "aws_region" "current" {}

resource "null_resource" "init" {
  triggers = {
    containers = local.repolist
  }
  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name ${module.build.project_name} --region ${data.aws_region.current.name} > /dev/null"
  }
}