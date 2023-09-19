data "aws_route53_zone" "selected" {
  count        = var.create_record ? 1 : 0
  name         = var.zone_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "record" {
  count = var.create_record ? length(var.record_names) : 0

  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = var.record_names[count.index]
  type    = var.record_type

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = var.evaluate_target_health
  }

  allow_overwrite = var.allow_record_overwrite
}
