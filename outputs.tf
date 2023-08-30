output "db_parameters" {
  description = "List of RDS Parameters"
  sensitive   = true
  value       = module.db_parameters.parameters
}

output "efs_parameters" {
  description = "List of EFS Parameters"
  sensitive   = true
  value       = module.efs_parameters.parameters
}
