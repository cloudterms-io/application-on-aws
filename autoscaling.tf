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

  name_prefix = "cloud-"

  create_launch_template  = false
  launch_template         = aws_launch_template.this.name
  launch_template_version = aws_launch_template.this.latest_version
  vpc_zone_identifier     = module.vpc.public_subnet_id


  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  wait_for_capacity_timeout = 0
  health_check_type         = "ELB"
  health_check_grace_period = 300

  enable_monitoring = true
}