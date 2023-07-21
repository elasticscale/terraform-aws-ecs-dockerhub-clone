
resource "null_resource" "init" {
    triggers = {
      containers = local.repolist
    }
    provisioner "local-exec" {
        command = "aws codebuild start-build --project-name ${module.build.project_name} --region ${var.region} > /dev/null"
    }
}