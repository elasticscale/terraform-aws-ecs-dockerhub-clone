variable "containers" {
  type        = map(list(string))
  description = "Containers to clone including tags"
}
variable "build_commands" {
  type        = map(list(string))
  description = "This allows you to add additional lines to the Dockerfile before pushing to ECR"
  default     = {}
}
variable "namespace" {
  type        = string
  description = "Prefix to add before all pulled containers to prevent conflicts"
  default     = "ecsclone"
}
variable "prefix" {
  type        = string
  description = "Prefix to add to all resources"
  default     = "ecs-clone-"
}
variable "docker_hub_username" {
  type        = string
  description = "Docker Hub username"
}
variable "docker_hub_access_token" {
  type        = string
  description = "Docker Hub access token (public repo read only access)"
}

variable "region" {
  type        = string
  description = "AWS region (default to caller region)"
  default     = null
}

variable "account_id" {
  type        = string
  description = "AWS account ID (default to caller ID)"
  default     = null
}