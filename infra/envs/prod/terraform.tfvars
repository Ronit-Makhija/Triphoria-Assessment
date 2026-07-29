environment  = "prod"
region       = "ap-south-1"
offline_mode = true

vpc_cidr           = "10.20.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]

public_subnet_cidrs = ["10.20.0.0/24", "10.20.1.0/24"]
app_subnet_cidrs    = ["10.20.10.0/24", "10.20.11.0/24"]
db_subnet_cidrs     = ["10.20.20.0/24", "10.20.21.0/24"]
single_nat_gateway  = false

container_image = "nginx:1.27-alpine"
task_cpu        = 512
task_memory     = 1024
desired_count   = 2

db_instance_class               = "db.t4g.small"
db_allocated_storage            = 50
db_max_allocated_storage        = 200
db_multi_az                     = true
db_backup_retention_period      = 14
db_deletion_protection          = true
db_performance_insights_enabled = true
