# module "ec2_instance" {
#   source = "terraform-aws-modules/ec2-instance/aws"

#   name = "access-test"

#   instance_type          = "t2.micro"
#   key_name               = "ec2-access"
#   monitoring             = false
#   vpc_security_group_ids = [aws_security_group.public_sg.id, aws_security_group.demo_sg.id]
#   subnet_id              = module.vpc.public_subnet_id[0]
#   iam_instance_profile   = module.instance_profile.profile_name

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }
