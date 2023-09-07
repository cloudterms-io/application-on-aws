locals {
  asg_launch_template_name    = module.launch_template.name
  asg_launch_template_version = module.launch_template.latest_version
  asg_vpc_zone_identifier     = coalesce(module.vpc.public_subnet_id, var.asg_vpc_zone_identifier)
  asg_name                    = coalesce(var.asg_name, "${var.project_name}-asg")
  asg_target_group_arns       = module.alb.target_group_arns
}

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"
  create = true
  # Do not create launch template as part of asg. 
  # launch templated created separatly 
  create_launch_template = false

  name                    = local.asg_name
  launch_template         = local.asg_launch_template_name
  launch_template_version = local.asg_launch_template_version
  vpc_zone_identifier     = local.asg_vpc_zone_identifier

  desired_capacity = var.asg_desired_capacity
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size

  target_group_arns = local.asg_target_group_arns

  wait_for_capacity_timeout = var.asg_wait_for_capacity_timeout
  health_check_type         = var.asg_health_check_type
  health_check_grace_period = var.asg_health_check_grace_period

  enable_monitoring = var.asg_enable_monitoring

  tags = merge(
    { "Name" = local.asg_name },
    var.general_tags,
  )
}
