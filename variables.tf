variable "region" {
  type        = string
  description = "AWS region to launch the resources in"
}
variable "containers" {
  type        = map(list(string))
  description = "Containers to clone including tags"
}
variable "docker_hub_username" {
  type        = string
  description = "Docker Hub username"
}
variable "docker_hub_access_token" {
  type        = string
  description = "Docker Hub access token (public repo read only access)"
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
variable "schedule_expression" {
  type        = string
  default     = "cron(0 9 ? * * *)"
  description = "EventBridge schedule expression ie how often to download the new images"
}