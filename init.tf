
resource "null_resource" "init" {
  triggers = {
    containers = local.repolist
    name       = aws_codebuild_project.main.name
  }
  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name ${aws_codebuild_project.main.name} --region ${data.aws_region.current.name} > /dev/null"
  }
}