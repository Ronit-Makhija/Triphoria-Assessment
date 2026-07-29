variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "region" {
  description = "AWS region."
  type        = string
}

variable "offline_mode" {
  description = "Use mock credentials and skip AWS account checks for local planning."
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for the environment VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used by the environment."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "Private application subnet CIDR blocks."
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "Isolated database subnet CIDR blocks."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway for all private application subnets."
  type        = bool
}

variable "container_image" {
  description = "Application container image."
  type        = string
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
  description = "Desired ECS task count."
  type        = number
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "db_allocated_storage" {
  description = "Initial RDS storage in GiB."
  type        = number
}

variable "db_max_allocated_storage" {
  description = "Maximum autoscaled RDS storage in GiB."
  type        = number
}

variable "db_multi_az" {
  description = "Deploy RDS across multiple availability zones."
  type        = bool
}

variable "db_backup_retention_period" {
  description = "RDS automated backup retention in days."
  type        = number
}

variable "db_deletion_protection" {
  description = "Enable RDS deletion protection."
  type        = bool
}

variable "db_performance_insights_enabled" {
  description = "Enable RDS Performance Insights."
  type        = bool
}
