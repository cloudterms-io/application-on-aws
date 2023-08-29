resource "aws_efs_file_system" "this" {
  creation_token   = var.name
  encrypted        = var.efs_encrypted
  throughput_mode  = var.efs_throughput_mode
  performance_mode = var.efs_performance_mode

  lifecycle_policy {
    transition_to_ia = var.efs_transition_to_ia
  }

  tags = var.efs_tags
}

resource "aws_efs_mount_target" "efs_mount" {
  count           = length(var.efs_subnet_ids)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.efs_subnet_ids[count.index]
  security_groups = var.security_group_ids
}
