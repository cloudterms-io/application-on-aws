output "id" {
  description = "ID of the EFS file system"
  value       = aws_efs_file_system.this.id
}

output "mount_target_ids" {
  description = "List of IDs of EFS mount targets"
  value       = aws_efs_mount_target.efs_mount[*].id
}
