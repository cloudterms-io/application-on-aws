# resource "aws_autoscaling_group" "this" {
#  name_prefix = "cloudapp"

#  desired_capacity = 2
#  min_size         = 2
#  max_size         = 4


#  launch_template {
#     id      = aws_launch_template.this.id
#     version = aws_launch_template.this.latest_version
#  }

#  vpc_zone_identifier = module.vpc.public_subnet_id
# }

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"
  create = false

  name                    = "cloud"
  create_launch_template  = false
  launch_template         = module.launch_template.name
  launch_template_version = module.launch_template.latest_version
  vpc_zone_identifier     = module.vpc.public_subnet_id

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  target_group_arns = module.alb.target_group_arns

  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  health_check_grace_period = 300

  enable_monitoring = true
}