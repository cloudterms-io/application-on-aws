#######################################
# Create custom policy
#######################################
module "custom_iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  create_policy = var.create_custom_policy

  name_prefix = var.custom_iam_policy_name_prefix
  path        = var.custom_iam_policy_path
  description = coalesce(var.custom_iam_policy_description, var.custom_iam_policy_name_prefix)

  policy = var.custom_iam_policy_json

  tags = merge(
    { "Type" = "Custom-Policy" },
    var.general_tags,
  )
}


#######################################
# IAM Instance profile
#######################################
locals {
  instance_profile_custom_policy_arns       = compact(concat(var.instance_profile_custom_policy_arns, [module.custom_iam_policy.arn]))
  instance_profile_custom_policy_arns_count = length(var.instance_profile_custom_policy_arns) + (var.create_custom_policy ? 1 : 0)
}

module "instance_profile" {

  source = "./modules/iam-instance-profile"

  create_instance_profile  = var.instance_profile_create_instance_profile
  role_name                = var.instance_profile_role_name
  instance_profile_name    = var.instance_profile_instance_profile_name
  managed_policy_arns      = var.instance_profile_managed_policy_arns
  custom_policy_arns       = local.instance_profile_custom_policy_arns
  custom_policy_arns_count = local.instance_profile_custom_policy_arns_count
  role_path                = var.instance_profile_role_path

  depends_on = [module.custom_iam_policy]
}
