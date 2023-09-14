data "aws_route53_zone" "selected" {
  name         = var.zone_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "record" {
  count = var.create_record ? 1 : 0

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.record_name
  type    = var.record_type

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}
