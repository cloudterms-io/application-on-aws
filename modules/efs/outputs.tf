output "id" {
  description = "ID of the EFS file system"
  value       = try(aws_efs_file_system.this[0].id, null)
}

output "mount_target_ids" {
  description = "List of IDs of EFS mount targets"
  value       = try(aws_efs_mount_target.efs_mount[*].id, null)
}
