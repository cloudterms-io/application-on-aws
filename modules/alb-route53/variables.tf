variable "create_record" {
  description = "Whether to create DNS record"
  type        = bool
  default     = true
}

variable "zone_name" {
  description = "The name of the Route 53 zone"
  type        = string
  default     = ""
}

variable "record_name" {
  description = "The name of the Route 53 record"
  type        = string
  default     = ""
}

variable "record_type" {
  description = "The type of the Route 53 record (e.g., A, CNAME, etc.)"
  type        = string
  default     = ""
}

variable "lb_dns_name" {
  description = "The DNS name to which the record should alias"
  type        = string
  default     = ""
}

variable "lb_zone_id" {
  description = "The Route 53 zone ID of the alias target"
  type        = string
  default     = ""
}

variable "private_zone" {
  description = "Whether the Route 53 zone is private or not"
  type        = bool
  default     = false
}

variable "evaluate_target_health" {
  description = "Whether to evaluate the target health of the alias record"
  type        = bool
  default     = true
}
