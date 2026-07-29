variable "name_prefix" {
  description = "Prefix used for database resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC containing the database."
  type        = string
}

variable "db_subnet_ids" {
  description = "Isolated subnet IDs for RDS."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ECS security group permitted to connect to PostgreSQL."
  type        = string
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "allocated_storage" {
  description = "Initial database storage in GiB."
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled database storage in GiB."
  type        = number
}

variable "multi_az" {
  description = "Whether to deploy a synchronous standby in another AZ."
  type        = bool
}

variable "backup_retention_period" {
  description = "Number of days automated backups are retained."
  type        = number
}

variable "deletion_protection" {
  description = "Protect the database from accidental deletion."
  type        = bool
}

variable "performance_insights_enabled" {
  description = "Enable RDS Performance Insights."
  type        = bool
}
