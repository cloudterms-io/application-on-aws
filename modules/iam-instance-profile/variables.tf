variable "create_instance_profile" {
  description = "Determine whether to create an instance profile"
  type        = bool
  default     = true
}

variable "role_name" {
  description = "Name of the role"
  type        = string
  default     = ""
}

variable "instance_profile_name" {
  description = "Name of the instance profile name"
  type        = string
  default     = ""
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "custom_policy_arns" {
  description = "List of custom policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "role_path" {
  description = "Path for the IAM role"
  type        = string
  default     = "/"
}
