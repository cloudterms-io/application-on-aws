output "primary_db_parameters" {
  description = "List of Primary DB Parameters"
  sensitive   = true
  value       = module.primary_db_parameters.parameters
}

output "replica_db_parameters" {
  description = "List of Primary DB Parameters"
  sensitive   = true
  value       = module.replica_db_parameters.parameters
}

output "efs_parameters" {
  description = "List of EFS Parameters"
  sensitive   = true
  value       = module.efs_parameters.parameters
}
