##################### ACM - Route53 #########################
module "acm_route53" {

  source = "shamimice03/acm-route53/aws"

  domain_name            = var.acm_domain_name
  validation_method      = var.acm_validation_method
  hosted_zone_name       = var.acm_hosted_zone_name
  private_zone           = var.acm_private_zone
  allow_record_overwrite = var.acm_allow_record_overwrite
  ttl                    = var.acm_ttl
  tags = merge(
    { "Name" = var.acm_domain_name },
    var.general_tags,
  )
}

##################### ALB #########################
locals {
  vpc_id                       = module.vpc.vpc_id
  alb_subnets                  = module.vpc.public_subnet_id
  alb_security_groups          = [module.alb_sg.security_group_id]
  alb_name_prefix              = coalesce(var.alb_name_prefix, "refalb")
  alb_target_group_name_prefix = coalesce(var.alb_target_group_name_prefix, "ref-tg")
  alb_certificate_arn          = module.acm_route53.certificate_arn
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name_prefix        = local.alb_name_prefix
  load_balancer_type = var.load_balancer_type
  vpc_id             = local.vpc_id
  subnets            = local.alb_subnets
  security_groups    = local.alb_security_groups

  #  access_logs = {
  #     bucket = "my-alb-logs"
  #  }

  target_groups = [
    {
      name_prefix      = local.alb_target_group_name_prefix
      target_type      = "instance"
      backend_port     = 80
      backend_protocol = "HTTP"
      protocol_version = "HTTP1"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = local.alb_certificate_arn
      action_type        = "forward"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  tags = merge(
    { "Name" = local.alb_name_prefix },
    var.general_tags,
  )
}

##################### ALB - Route53 ###################
locals {
  alb_dns_name = module.alb.lb_dns_name
  alb_zone_id  = module.alb.lb_zone_id
}

module "alb_route53_record_1" {
  source                 = "./modules/alb-route53"
  zone_name              = var.alb_route53_zone_name
  record_name            = var.alb_route53_record_name_1
  record_type            = var.alb_route53_record_type
  lb_dns_name            = local.alb_dns_name
  lb_zone_id             = local.alb_zone_id
  private_zone           = var.alb_route53_private_zone
  evaluate_target_health = var.alb_route53_evaluate_target_health
}

module "alb_route53_record_2" {
  source                 = "./modules/alb-route53"
  zone_name              = var.alb_route53_zone_name
  record_name            = var.alb_route53_record_name_2
  record_type            = var.alb_route53_record_type
  lb_dns_name            = local.alb_dns_name
  lb_zone_id             = local.alb_zone_id
  private_zone           = var.alb_route53_private_zone
  evaluate_target_health = var.alb_route53_evaluate_target_health
}
