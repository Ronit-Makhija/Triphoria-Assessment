variable "name_prefix" {
  description = "Prefix used for ECS and ALB resource names."
  type        = string
}

variable "region" {
  description = "AWS region used by the CloudWatch log driver."
  type        = string
}

variable "vpc_id" {
  description = "VPC containing the service."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB."
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "Private subnet IDs for Fargate tasks."
  type        = list(string)
}

variable "container_image" {
  description = "Container image run by the service."
  type        = string
  default     = "nginx:1.27-alpine"
}

variable "container_port" {
  description = "Port exposed by the application container."
  type        = number
  default     = 80
}

variable "task_cpu" {
  description = "Fargate task CPU units."
  type        = number
}

variable "task_memory" {
  description = "Fargate task memory in MiB."
  type        = number
}

variable "desired_count" {
  description = "Desired number of ECS tasks."
  type        = number
}
