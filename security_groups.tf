locals {
  vpc = module.vpc.vpc_id

  alb_sg_description = "Allow HTTP and HTTPS traffic from anywhere"
  ec2_sg_description = "Allow inbound traffic from ALB"
  efs_sg_description = "Allow inbound traffic from ec2-sg"
  rds_sg_description = "Allow inbound traffic from ec2-sg"
  ssh_sg_description = "Allow SSH from anywhere"

  alb_sg_name = coalesce(var.alb_sg_name, "alb-sg")
  ec2_sg_name = coalesce(var.ec2_sg_name, "ec2-sg")
  efs_sg_name = coalesce(var.efs_sg_name, "efs-sg")
  rds_sg_name = coalesce(var.rds_sg_name, "rds-sg")
  ssh_sg_name = coalesce(var.ssh_sg_name, "ssh-sg")
}

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = true

  vpc_id      = local.vpc
  name        = local.alb_sg_name
  description = local.alb_sg_description

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]

  egress_rules       = ["all-tcp"]
  egress_cidr_blocks = var.public_subnet_cidr
}

module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = true

  vpc_id      = local.vpc
  name        = local.ec2_sg_name
  description = local.ec2_sg_description

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_sg.security_group_id
    },
  ]

  egress_rules       = ["all-tcp"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

module "efs_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = true

  vpc_id      = local.vpc
  name        = local.efs_sg_name
  description = local.efs_sg_description

  ingress_with_source_security_group_id = [
    {
      rule                     = "nfs-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]

  egress_with_source_security_group_id = [
    {
      rule                     = "nfs-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]
}

module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = true

  vpc_id      = local.vpc
  name        = local.rds_sg_name
  description = local.rds_sg_description

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]

  egress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]
}

module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  create = true

  vpc_id      = local.vpc
  name        = local.ssh_sg_name
  description = local.ssh_sg_description

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["ssh-tcp"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}




# locals {
#   vpc                   = module.vpc.vpc_id
#   alb_sg_description    = "Allow inbound traffic to ALB"
#   public_sg_description = "Allow inbound traffic from ALB"
#   efs_sg_description    = "Allow inbound traffic from public instances"
#   rds_sg_description    = "Allow inbound traffic from public sg"
# }

# #################################################
# #   Security Groups
# #################################################
# resource "aws_security_group" "alb_sg" {
#   name        = var.alb_sg_name
#   description = local.alb_sg_description
#   vpc_id      = local.vpc

#   dynamic "ingress" {
#     for_each = var.alb_sg_ingress_ports
#     iterator = port
#     content {
#       description = "Traffic from anywhere"
#       from_port   = port.value
#       to_port     = port.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_security_group" "public_sg" {
#   name        = var.public_sg_name
#   description = local.public_sg_description
#   vpc_id      = local.vpc

#   dynamic "ingress" {
#     for_each = var.public_sg_ingress_ports
#     iterator = port
#     content {
#       description     = "Traffic from ALB"
#       from_port       = port.value
#       to_port         = port.value
#       protocol        = "tcp"
#       security_groups = [aws_security_group.alb_sg.id] # from ALB SG
#     }
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_security_group" "efs_sg" {
#   name        = var.efs_sg_name
#   description = local.efs_sg_description
#   vpc_id      = local.vpc

#   dynamic "ingress" {
#     for_each = var.efs_sg_ingress_ports
#     iterator = port
#     content {
#       description     = "Allow from public sg"
#       from_port       = port.value
#       to_port         = port.value
#       protocol        = "tcp"
#       security_groups = [aws_security_group.public_sg.id] # from public sg
#     }
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_security_group" "rds_sg" {
#   name        = var.rds_sg_name
#   description = local.rds_sg_description
#   vpc_id      = local.vpc

#   dynamic "ingress" {
#     for_each = var.rds_sg_ingress_ports
#     iterator = port
#     content {
#       description     = "Allow from public sg"
#       from_port       = port.value
#       to_port         = port.value
#       protocol        = "tcp"
#       security_groups = [aws_security_group.public_sg.id] # allow from public sg
#     }
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = [module.vpc.vpc_cidr_block] # egress to vpc network
#   }
# }

# #################################################
# #       SSH SG
# #################################################
# resource "aws_security_group" "demo_sg" {
#   name        = "SSH-SG"
#   description = "Allow inbound traffic"
#   vpc_id      = module.vpc.vpc_id

#   dynamic "ingress" {
#     for_each = [22]
#     iterator = port
#     content {
#       description = "Traffic from anywhere"
#       from_port   = port.value
#       to_port     = port.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }
