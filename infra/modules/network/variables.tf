variable "name_prefix" {
  description = "Prefix used for network resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used by all subnet tiers."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two availability zones are required."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public ALB subnets."
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for private ECS subnets."
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for isolated RDS subnets."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway instead of one per availability zone."
  type        = bool
  default     = true
}
