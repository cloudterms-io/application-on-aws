variable "create" {
  description = "Whether to create EFS resources"
  type        = bool
  default     = true
}

variable "name" {
  description = "A unique name used as reference when creating the Elastic File System to ensure idempotent file system creation"
  type        = string
  default     = ""
}

variable "efs_mount_target_subnet_ids" {
  description = "List of mount targets subnet IDs"
  type        = list(string)
  default     = []
}

variable "efs_mount_target_security_group_ids" {
  description = "IDs of the mount targets security group for EFS"
  type        = list(string)
  default     = []
}

variable "efs_encrypted" {
  description = "Whether EFS should be encrypted"
  type        = bool
  default     = true
}

# variable "kms_key_id" {
#   description = "The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true"
#   type        = string
#   default     = ""
# }

variable "efs_throughput_mode" {
  description = "EFS throughput mode (e.g., 'provisioned', 'bursting','elastic)"
  type        = string
  default     = "bursting"
}

variable "efs_performance_mode" {
  description = "EFS performance mode (e.g., 'generalPurpose', 'maxIO')"
  type        = string
  default     = "generalPurpose"
}

variable "efs_transition_to_ia" {
  description = "Indicates how long it takes to transition files to the IA storage class. Valid values: AFTER_1_DAY, AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, or AFTER_90_DAYS"
  type        = string
  default     = "AFTER_30_DAYS"
}

variable "efs_tags" {
  description = "Tags for the EFS file system"
  type        = map(string)
  default     = {}
}
