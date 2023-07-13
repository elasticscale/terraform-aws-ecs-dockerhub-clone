<!-- BEGIN_TF_DOCS -->

## Description

This module is able to use your Docker Hub details and periodically clone Docker Hub repo's to private ECR repositories. This way you won't run into Docker Hub rate limits. If you pair it with a VPC endpoint you can get improved pull results (and perhaps use this in a stricter environment with no internet access).

Your Docker Hub access token needs to have public repo pull permissions.

An example of the containers variable:

    containers = {
      "mongo"           = ["latest"],
      "redis"           = ["latest"],
      "hashicorp/vault" = ["1.14", "1.13.3"],
    }

For more debugging steps check out [the elasticscale blog](https://elasticscale.cloud/en/use-pull-through-caches-on-ecr-to-circumvent-docker-hub-rate-limits/).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.67.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_build"></a> [build](#module\_build) | cloudposse/codebuild/aws | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.cron](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.codebuild](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/cloudwatch_event_target) | resource |
| [aws_ecr_repository.ecr](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/ecr_repository) | resource |
| [aws_iam_role.cloudwatch_event](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/iam_role) | resource |
| [aws_ssm_parameter.accesstoken](https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_containers"></a> [containers](#input\_containers) | Containers to clone including tags | `map(list(string))` | n/a | yes |
| <a name="input_docker_hub_access_token"></a> [docker\_hub\_access\_token](#input\_docker\_hub\_access\_token) | Docker Hub access token (public repo read only access) | `string` | n/a | yes |
| <a name="input_docker_hub_username"></a> [docker\_hub\_username](#input\_docker\_hub\_username) | Docker Hub username | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to add before all pulled containers to prevent conflicts | `string` | `"ecsclone"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix to add to all resources | `string` | `"ecs-clone-"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to launch the resources in | `string` | n/a | yes |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | EventBridge schedule expression ie how often to download the new images | `string` | `"cron(0 9 ? * * *)"` | no |

## Outputs

No outputs.