locals {
  vpc_id              = module.vpc.vpc_id
  alb_subnets         = module.vpc.public_subnet_id
  alb_security_groups = [module.alb_sg.security_group_id]
}

module "acm_route53" {

  source = "shamimice03/acm-route53/aws"

  domain_name            = "demo.kubecloud.net"
  validation_method      = "DNS"
  hosted_zone_name       = "kubecloud.net"
  private_zone           = false
  allow_record_overwrite = true
  ttl                    = 60
  tags = {
    "Name" = "ssl-cert"
  }
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name_prefix        = "cloud-"
  load_balancer_type = "application"
  vpc_id             = local.vpc_id
  subnets            = local.alb_subnets
  security_groups    = local.alb_security_groups

  #  access_logs = {
  #     bucket = "my-alb-logs"
  #  }

  target_groups = [
    {
      name_prefix      = "app-tg"
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
      certificate_arn    = module.acm_route53.certificate_arn
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

  tags = {
    Environment = "Test"
  }
}

module "alb_route53_record_1" {
  source                 = "./modules/alb-route53"
  zone_name              = "kubecloud.net."
  record_name            = "demo.kubecloud.net"
  record_type            = "A"
  lb_dns_name            = module.alb.lb_dns_name
  lb_zone_id             = module.alb.lb_zone_id
  private_zone           = false
  evaluate_target_health = true
}

module "alb_route53_record_2" {
  source                 = "./modules/alb-route53"
  zone_name              = "kubecloud.net."
  record_name            = "www.demo.kubecloud.net"
  record_type            = "A"
  lb_dns_name            = module.alb.lb_dns_name
  lb_zone_id             = module.alb.lb_zone_id
  private_zone           = false
  evaluate_target_health = true
}
