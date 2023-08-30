#################################################
#   Security groups
#################################################
resource "aws_security_group" "alb_sg" {
  name        = "aws-ref-arch-alb-sg"
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
  name        = "aws-ref-arch-public-sg"
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
  name        = "aws-ref-arch-efs-sg"
  description = "Allow inbound traffic from public instances"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [2049]
    iterator = port
    content {
      description     = "Allow from public sg"
      from_port       = port.value
      to_port         = port.value
      protocol        = "tcp"
      security_groups = [aws_security_group.public_sg.id] # from public sg
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
  name        = "aws-ref-arch-rds-sg"
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
      security_groups = [aws_security_group.public_sg.id] # allow from public sg
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}

#################################################
#       Demo EC2 on public subnet
#################################################
resource "aws_security_group" "demo_sg" {
  name        = "${var.project_name}-demo-sg"
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
