variable "project_name" {
  description = "Name of the role"
  type        = string
  default     = "aws-ref-architecture"
}

variable "general_tags" {
  description = "General tags to apply to resources created"
  type        = map(string)
  default = {
    "Project_name" = "aws-ref-architecture"
    "Team"         = "platform-team"
    "Env"          = "dev"
  }
}

# VPC
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "aws-ref-arch-vpc"
}

# RDS
variable "db_identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = "aws-ref-arch-db-1"
}

variable "db_engine" {
  description = "The type of DB Engine"
  type        = string
  default     = "mysql"
}

# EFS
variable "efs_name" {
  description = "Name of the Elastic File System"
  type        = string
  default     = "aws-ref-arch-efs"
}