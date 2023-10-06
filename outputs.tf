output "image_base_url" {
  description = "The base URL for your ECR images from Docker Hub"
  value       = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${var.namespace}/"
}