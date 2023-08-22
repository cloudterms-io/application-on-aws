locals {
  project_name = "wordpress-on-cloud"
}

#################################################
#   VPC
#################################################
module "vpc" {

  source = "shamimice03/vpc/aws"

  vpc_name = "wordpress-on-cloud"
  cidr     = "10.3.0.0/16"

  azs                 = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnet_cidr  = ["10.3.0.0/20", "10.3.16.0/20", "10.3.32.0/20"]
  private_subnet_cidr = ["10.3.48.0/20", "10.3.64.0/20", "10.3.80.0/20"]
  db_subnet_cidr      = ["10.3.96.0/20", "10.3.112.0/20", "10.3.128.0/20"]

  enable_dns_hostnames      = true
  enable_dns_support        = true
  enable_single_nat_gateway = false

  tags = {
    "Team" = "devops"
    "Env"  = "prod"
  }
}


#################################################
#   Security groups
#################################################
resource "aws_security_group" "alb_sg" {
  name        = "${local.project_name}-alb-sg"
  description = "Allow inbound traffic to ALB"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [80, 443]
    iterator = port
    content {
      description = "Traffic from anywhere"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "public_sg" {
  name        = "${local.project_name}-public-sg"
  description = "Allow inbound traffic from ALB"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [80]
    iterator = port
    content {
      description     = "Traffic from ALB"
      from_port       = port.value
      to_port         = port.value
      protocol        = "tcp"
      security_groups = [aws_security_group.alb_sg.id] # from ALB SG
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "${local.project_name}-efs-sg"
  description = "Allow inbound traffic from public sg"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [2049]
    iterator = port
    content {
      description     = "Allow from public sg"
      from_port       = port.value
      to_port         = port.value
      protocol        = "tcp"
      security_groups = [aws_security_group.public_sg.id]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${local.project_name}-rds-sg"
  description = "Allow inbound traffic from public sg"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [3306]
    iterator = port
    content {
      description     = "Allow from public sg"
      from_port       = port.value
      to_port         = port.value
      protocol        = "tcp"
      security_groups = [aws_security_group.public_sg.id]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}

####################################
#    RDS
####################################

module "rds" {
  source = "shamimice03/rds-blueprint/aws"

  # DB Subnet Group
  create_db_subnet_group = true
  db_subnet_group_name   = "${local.project_name}-db-subnet"
  db_subnets             = module.vpc.db_subnet_id

  # Identify DB instance
  db_identifier = "${local.project_name}-db-1"

  # Create Initial Database
  db_name = "mydb"

  # Credentials Settings
  db_master_username = "admin"
  #db_master_password                  = random_password.password.result
  iam_database_authentication_enabled = false

  # Availability and durability
  multi_az = false

  # Engine options
  engine         = "mysql"
  engine_version = "8.0"

  # DB Instance configurations
  instance_class = "db.t3.micro"

  # Storage
  storage_type          = "gp2"
  allocated_storage     = "20"
  max_allocated_storage = "20"

  # Connectivity
  db_security_groups  = [aws_security_group.rds_sg.id]
  publicly_accessible = false
  database_port       = 3306

  # Backup and Maintenance
  backup_retention_period = 7
  backup_window           = "03:00-05:00"
  maintenance_window      = "Sat:05:00-Sat:07:00"
  deletion_protection     = false

  # Monitoring
  enabled_cloudwatch_logs_exports = ["audit", "error"]

  # Others
  apply_immediately        = true
  delete_automated_backups = true
  skip_final_snapshot      = true

}

####################################
#   EFS
####################################
resource "aws_efs_file_system" "efs" {
  creation_token = "${local.project_name}-efs"

  encrypted        = true
  throughput_mode  = "bursting"
  performance_mode = "generalPurpose"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "${local.project_name}-efs"
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  count           = length(module.vpc.private_subnet_id)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.vpc.private_subnet_id[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}

#################################################
#       DB Parameters
#################################################
module "db_parameters" {

  source = "shamimice03/ssm-parameter/aws"

  parameters = [
    {
      name        = "/wordpress/db/DBUser"
      type        = "String"
      description = "Database Username"
      value       = module.rds.db_instance_username
      tags = {
        "Name" = "${local.project_name}"
      }
    },
    {
      name        = "/wordpress/db/DBName"
      type        = "String"
      description = "Initial Database Name"
      value       = module.rds.db_name
      tags = {
        "Name" = "${local.project_name}"
      }
    },
    {
      name        = "/wordpress/db/DBEndpoint"
      type        = "String"
      description = "Database Instance Endpoint"
      value       = module.rds.db_instance_endpoint
      tags = {
        "Name" = "${local.project_name}"
      }
    },
    {
      name        = "/wordpress/db/DBHostname"
      type        = "String"
      description = "Database Instance Hostname"
      value       = module.rds.db_instance_address
      tags = {
        "Name" = "${local.project_name}"
      }
    },
    {
      name        = "/wordpress/db/DBPort"
      type        = "String"
      description = "Database Instance Port"
      value       = module.rds.db_instance_port
      tags = {
        "Name" = "${local.project_name}"
      }
    },
    {
      name        = "/wordpress/db/DBPassword"
      type        = "SecureString"
      description = "Database password"
      value       = module.rds.db_instance_password
      key_alias   = "alias/aws/ssm"
      tags = {
        "Name" = "${local.project_name}"
      }
    },
  ]
}

#################################################
#       EFS Parameters
#################################################
module "efs_parameters" {

  source = "shamimice03/ssm-parameter/aws"

  parameters = [
    {
      name        = "/wordpress/efs/EFSID"
      type        = "String"
      description = "The ID that identifies the file system"
      value       = aws_efs_file_system.efs.id
      tags = {
        "Name" = "${local.project_name}"
      }
    },
  ]
}

#################################################
#       IAM Role
#################################################
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name               = "${local.project_name}-Role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess",
  ]
}

resource "aws_iam_instance_profile" "instance_role" {
  name = "${local.project_name}-InstanceRole"
  role = aws_iam_role.role.name
}

#################################################
#       Demo EC2 on public
#################################################
resource "aws_security_group" "demo_sg" {
  name        = "${local.project_name}-demo-sg"
  description = "Allow inbound traffic"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [22]
    iterator = port
    content {
      description = "Traffic from anywhere"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "access-test"

  instance_type          = "t2.micro"
  key_name               = "ec2-access"
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.public_sg.id, aws_security_group.demo_sg.id]
  subnet_id              = module.vpc.public_subnet_id[0]
  iam_instance_profile   = aws_iam_instance_profile.instance_role.name

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}