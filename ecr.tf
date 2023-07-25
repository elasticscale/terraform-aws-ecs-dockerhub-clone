resource "aws_ecr_repository" "ecr" {
  for_each             = var.containers
  name                 = "${var.namespace}/${each.key}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

resource "aws_ecr_lifecycle_policy" "foopolicy" {
  for_each   = aws_ecr_repository.ecr
  repository = each.value.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Remove untagged images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}