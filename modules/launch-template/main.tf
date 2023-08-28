resource "aws_launch_template" "this" {

  count = var.create ? 1 : 0

  name_prefix            = var.launch_template_name_prefix
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  update_default_version = var.update_default_version
  vpc_security_group_ids = var.vpc_security_group_ids

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  block_device_mappings {
    device_name = var.device_name

    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = var.delete_on_termination
    }
  }

  monitoring {
    enabled = var.enable_monitoring
  }
  user_data = var.user_data_file_path

  tag_specifications {
    resource_type = var.resource_type
    tags          = var.tags
  }
}
