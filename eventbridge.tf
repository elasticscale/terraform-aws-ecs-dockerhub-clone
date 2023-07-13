resource "aws_cloudwatch_event_rule" "cron" {
  name                = "${var.prefix}-cron"
  description         = "Downloads the Docker Hub images to ECR perodically"
  schedule_expression = var.schedule_expression
}

// iam role for cloudwatch event
resource "aws_iam_role" "cloudwatch_event" {
  name = "${var.prefix}-cloudwatch-event"
  inline_policy {
    // policy that StartBuild on Codebuild:
    name   = "cloudwatch-event"
    policy = <<EOF
{   
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "codebuild:StartBuild",
            "Resource": "${module.build.project_arn}"
        }
    ]
    
  }
EOF
  }
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "codebuild" {
  rule     = aws_cloudwatch_event_rule.cron.name
  arn      = module.build.project_arn
  role_arn = aws_iam_role.cloudwatch_event.arn
}