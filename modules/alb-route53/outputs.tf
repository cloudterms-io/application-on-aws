output "record_id" {
  description = "The ID of the Route 53 record"
  value       = aws_route53_record.record.id
}