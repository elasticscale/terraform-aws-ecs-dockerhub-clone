variable "region" {
  type        = string
  description = "AWS region to launch the resources in"
  // todo remove
  default = "eu-west-1"
}

variable "prefix" {
  type        = string
  description = "Prefix to add to all resources"
  default     = "ecs-clone-"

}