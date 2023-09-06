data "aws_ami" "amazonlinux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*"]
  }
}

locals {
  launch_template_sg_ids                    = [module.ec2_sg.security_group_id, module.ssh_sg.security_group_id]
  launch_template_image_id                  = coalesce(var.launch_template_image_id, data.aws_ami.amazonlinux2.id)
  launch_template_name_prefix               = coalesce(var.launch_template_name_prefix, var.project_name)
  launch_template_iam_instance_profile_name = module.instance_profile.profile_name
  launch_template_userdata_file_path        = join("/", [path.module, var.launch_template_userdata_file_path])
}

module "launch_template" {
  source = "./modules/launch-template"

  create = true

  launch_template_name_prefix = local.launch_template_name_prefix
  image_id                    = local.launch_template_image_id
  instance_type               = var.launch_template_instance_type
  key_name                    = var.launch_template_key_name
  update_default_version      = var.launch_template_update_default_version
  vpc_security_group_ids      = local.launch_template_sg_ids
  iam_instance_profile_name   = local.launch_template_iam_instance_profile_name
  device_name                 = var.launch_template_device_name
  volume_size                 = var.launch_template_volume_size
  volume_type                 = var.launch_template_volume_type
  delete_on_termination       = var.launch_template_delete_on_termination
  enable_monitoring           = var.launch_template_enable_monitoring
  user_data_file_path         = filebase64(local.launch_template_userdata_file_path)

  # tag_specifications
  resource_type = var.launch_template_resource_type
  tags = merge(
    { "Name" = local.launch_template_name_prefix },
    var.general_tags,
  )
}
