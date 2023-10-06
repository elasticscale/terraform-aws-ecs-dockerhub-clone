locals {
  repolist = join(",", [for k, repo in var.containers : join(",", [for tag in repo : "${k}:${tag}"])])
  buildstrings = {
    for k, repo in flatten([for k, repo in var.containers : [for tag in repo : "${k}:${tag}"]]) : "${repo}" => lookup(var.build_commands, repo, [])
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "main" {
  name               = "${var.prefix}codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]
    resources = [
      "arn:aws:ecr:${local.region}:${local.account_id}:repository/${var.namespace}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters"
    ]
    resources = [aws_ssm_parameter.accesstoken.arn]
  }
}

resource "aws_iam_role_policy" "main" {
  role   = aws_iam_role.main.name
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_codebuild_project" "main" {
  name          = "${var.prefix}codebuild"
  build_timeout = "480"
  service_role  = aws_iam_role.main.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "REPOLIST"
      value = local.repolist
    }
    environment_variable {
      name  = "BUILDSTRINGS"
      value = jsonencode(local.buildstrings)
    }
    environment_variable {
      name  = "NAMESPACE"
      value = var.namespace
    }
    environment_variable {
      name  = "AWS_REGION"
      value = local.region
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = local.account_id
    }
    environment_variable {
      name  = "DOCKERHUB_USERNAME"
      value = var.docker_hub_username
    }
    environment_variable {
      name  = "DOCKERHUB_TOKEN"
      value = aws_ssm_parameter.accesstoken.name
      type  = "PARAMETER_STORE"
    }
  }
  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/buildspec.yml")
  }
  logs_config {
    cloudwatch_logs {
      group_name  = "${var.prefix}log-group"
      stream_name = "${var.prefix}log-stream"
    }
  }
}