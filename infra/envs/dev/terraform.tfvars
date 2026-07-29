environment  = "dev"
region       = "ap-south-1"
offline_mode = true

vpc_cidr           = "10.10.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]

public_subnet_cidrs = ["10.10.0.0/24", "10.10.1.0/24"]
app_subnet_cidrs    = ["10.10.10.0/24", "10.10.11.0/24"]
db_subnet_cidrs     = ["10.10.20.0/24", "10.10.21.0/24"]
single_nat_gateway  = true

container_image = "nginx:1.27-alpine"
task_cpu        = 256
task_memory     = 512
desired_count   = 1

db_instance_class               = "db.t4g.micro"
db_allocated_storage            = 20
db_max_allocated_storage        = 50
db_multi_az                     = false
db_backup_retention_period      = 1
db_deletion_protection          = false
db_performance_insights_enabled = false
