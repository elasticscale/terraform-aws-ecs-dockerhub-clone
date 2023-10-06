## Description

This module is able to use your Docker Hub details and periodically clone Docker Hub repo's to private ECR repositories. This way you won't run into Docker Hub rate limits. If you pair it with a VPC endpoint you can get improved pull results (and perhaps use this in a stricter environment with no internet access).

Your Docker Hub access token needs to have public repo pull permissions (that is the only permission it needs as well). Otherwise the CodeBuild will run into rate limiting issues because the networking is shared.

An example of the containers variable:

    containers = {
      "mongo"           = ["latest"],
      "redis"           = ["latest"],
      "hashicorp/vault" = ["1.14", "1.13.3"],
    }

The paths of the images will be prefixed with the namespace variable to prevent conflicts. If your image URLs will be:

    XXXXX.dkr.ecr.eu-west-1.amazonaws.com/ecsclone/redis

This module also supports adding additional Dockerfile lines. This is helpful if you need to add VOLUME bind mounts to standard containers. For instance it can be used for Vault agent to creates a shared bind mount with the VOLUME keyword:

    build_commands = {
      "hashicorp/vault:1.14" = [
        "RUN mkdir /etc/vault",
        "RUN chmod 777 /etc/vault",
        "VOLUME [\"/etc/vault\"]"
      ]
    }

The resulting Dockerfile will be:

    FROM hashicorp/vault:1.14
    RUN mkdir /etc/vault
    RUN chmod 777 /etc/vault
    VOLUME ["/etc/vault"]

Now you can mount the same /etc/vault folder in your application containers and run them as a sidecar container. Vault can put the .env to the shared folder.  

There are also other usecases for this. You might need to initialize a standard Docker image with environment variables with ENV that are not initialized when the container was built. This allows you to customize the behaviour of standard public containers without running your own build pipeline. 

A fully working setup can be found in the examples folder.

For more debugging steps check out [the elasticscale blog](https://elasticscale.cloud/use-pull-through-caches-on-ecr-to-circumvent-docker-hub-rate-limits/).

## About ElasticScale

ElasticScale is a Solutions Architecture as a Service focusing on start-ups and scale-ups. For a fixed monthly subscription fee, we handle all your AWS workloads. Some services include:

* Migrating **existing workloads** to AWS
* Implementing the **Zero Trust security model**
* Integrating **DevOps principles** within your organization
* Moving to **infrastructure automation** (Terraform)
* Complying with **ISO27001 regulations within AWS**

You can **pause** the subscription at any time and have **direct access** to certified AWS professionals.

Check out our <a href="https://elasticscale.cloud" target="_blank" style="color: #14dcc0; text-decoration: underline">website</a> for more information.

<img src="https://elasticscale-public.s3.eu-west-1.amazonaws.com/logo/Logo_ElasticScale_4kant-transparant.png" alt="ElasticScale logo" width="150"/>

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_ecr_lifecycle_policy.foopolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource | A copy and paste error from my end but this deletes the images automatically if they get stale
| [aws_ecr_repository.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_ssm_parameter.accesstoken](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [null_resource.init](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS account ID | `string` | `null` | no |
| <a name="input_build_commands"></a> [build\_commands](#input\_build\_commands) | This allows you to add additional lines to the Dockerfile before pushing to ECR | `map(list(string))` | `{}` | no |
| <a name="input_containers"></a> [containers](#input\_containers) | Containers to clone including tags | `map(list(string))` | n/a | yes |
| <a name="input_docker_hub_access_token"></a> [docker\_hub\_access\_token](#input\_docker\_hub\_access\_token) | Docker Hub access token (public repo read only access) | `string` | n/a | yes |
| <a name="input_docker_hub_username"></a> [docker\_hub\_username](#input\_docker\_hub\_username) | Docker Hub username | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Prefix to add before all pulled containers to prevent conflicts | `string` | `"ecsclone"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix to add to all resources | `string` | `"ecs-clone-"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_image_base_url"></a> [image\_base\_url](#output\_image\_base\_url) | The base URL for your ECR images from Docker Hub |
