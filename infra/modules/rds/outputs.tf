output "endpoint" {
  description = "RDS connection endpoint."
  value       = aws_db_instance.this.endpoint
}

output "database_name" {
  description = "Name of the application database."
  value       = aws_db_instance.this.db_name
}

output "master_username" {
  description = "RDS master username."
  value       = aws_db_instance.this.username
}
