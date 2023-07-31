
resource "null_resource" "init" {
  triggers = {
    containers     = local.repolist
    name           = aws_codebuild_project.main.name
    build_commands = local.buildstrings
  }
  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name ${aws_codebuild_project.main.name} --region ${data.aws_region.current.name} > /dev/null"
  }
}