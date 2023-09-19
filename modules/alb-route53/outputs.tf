output "record_id" {
  description = "The ID of the Route 53 record"
  value       = try(aws_route53_record.record[*].id, null)
}
