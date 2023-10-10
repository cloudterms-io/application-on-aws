resource "aws_efs_file_system" "this" {
  count            = var.create ? 1 : 0
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
  count           = var.create ? var.efs_mount_target_subnet_count : 0
  file_system_id  = aws_efs_file_system.this[0].id
  subnet_id       = var.efs_mount_target_subnet_ids[count.index]
  security_groups = var.efs_mount_target_security_group_ids
}
