
locals {
  command = var.profile != null ? "aws codebuild start-build --profile ${var.profile} --project-name ${aws_codebuild_project.main.name} --region ${local.region} > /dev/null" : "aws codebuild start-build --project-name ${aws_codebuild_project.main.name} --region ${local.region} > /dev/null"
}

resource "null_resource" "init" {
  triggers = {
    containers     = local.repolist
    name           = aws_codebuild_project.main.name
    build_commands = jsonencode(local.buildstrings)
    command        = local.command
  }
  provisioner "local-exec" {
    command = local.command
  }
}