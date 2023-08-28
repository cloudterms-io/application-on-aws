output "name" {
  description = "Name of the AWS Launch Template"
  value       = try(aws_launch_template.this[0].name, null)
}

output "latest_version" {
  description = "Name of the AWS Launch Template"
  value       = try(aws_launch_template.this[0].latest_version, null)
}
