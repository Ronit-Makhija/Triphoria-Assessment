output "alb_dns_name" {
  description = "Public DNS name for the application."
  value       = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs.ecs_cluster_name
}

output "rds_endpoint" {
  description = "Private PostgreSQL endpoint."
  value       = module.rds.endpoint
}
