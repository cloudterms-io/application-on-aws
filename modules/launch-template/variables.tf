variable "create" {
  description = "Create the AWS Launch Template resource"
  type        = bool
  default     = true
}

variable "launch_template_name_prefix" {
  description = "Prefix for the launch template name"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "image_id" {
  description = "Amazon machine image id"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = ""
}

variable "update_default_version" {
  description = "Make latest version as default version"
  type        = bool
  default     = true
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of security groups"
  type        = list(any)
  default     = []
}

variable "volume_type" {
  description = "The volume type. Can be one of standard, gp2, gp3, io1, io2, sc1 or st1"
  type        = string
  default     = "gp2"
}

variable "volume_size" {
  description = "EBS volume size (in GB)"
  type        = number
  default     = 8
}

variable "delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled."
  type        = bool
  default     = false
}

variable "user_data_file_path" {
  description = "Path to the user data script file."
  type        = string
  default     = ""
}

variable "resource_type" {
  description = "The type of resource to tag."
  type        = string
  default     = "instance"
}

variable "tags" {
  description = "Tags for the launch template."
  type        = map(string)
  default     = {}
}
