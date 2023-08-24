data "aws_ami" "amazonlinux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*"]
  }
}

resource "aws_launch_template" "this" {
  name_prefix   = "cloudapp"
  image_id      = data.aws_ami.amazonlinux2.id
  instance_type = "t2.micro"
  key_name      = "ec2-access"

  update_default_version = true # Make latest version = default version

  vpc_security_group_ids = [aws_security_group.public_sg.id, aws_security_group.demo_sg.id]


  iam_instance_profile {
    name = aws_iam_instance_profile.instance_role.name
  }

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  user_data = filebase64("${path.module}/userdata.sh")
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }
}