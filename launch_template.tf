data "aws_ami" "amazonlinux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*"]
  }
}

module "launch_template" {
  source = "./modules/launch-template"

  create = true

  launch_template_name_prefix = "cloud"
  image_id                    = data.aws_ami.amazonlinux2.id
  instance_type               = "t3.micro"
  key_name                    = "ec2-access"
  update_default_version      = true
  vpc_security_group_ids      = [aws_security_group.public_sg.id, aws_security_group.demo_sg.id]
  iam_instance_profile_name   = module.instance_profile.profile_name
  volume_size                 = 20
  volume_type                 = "gp2"
  delete_on_termination       = true
  enable_monitoring           = false
  user_data_file_path         = filebase64("${path.module}/userdata.sh")

  resource_type = "instance"
  tags = {
    Name        = "cloud"
    Environment = "prod"
  }
}

