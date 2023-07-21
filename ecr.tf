resource "aws_ecr_repository" "ecr" {
  for_each             = var.containers
  name                 = "${var.namespace}/${each.key}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}