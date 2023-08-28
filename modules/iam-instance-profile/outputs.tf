output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this[0].arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.this[0].name
}

output "profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.this[0].arn
}

output "profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.this[0].name
}
