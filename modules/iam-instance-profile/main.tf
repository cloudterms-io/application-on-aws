locals {
  #policy_arns           = var.create_instance_profile ? var.custom_policy_arns : null
  role_name             = var.role_name != "" ? var.role_name : var.instance_profile_name
  instance_profile_name = coalesce(var.instance_profile_name, var.role_name)
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  count               = var.create_instance_profile ? 1 : 0
  name                = local.role_name
  path                = var.role_path
  assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json
  managed_policy_arns = toset(var.managed_policy_arns)
}

# resource "aws_iam_role_policy_attachment" "this" {
#   count = length(local.policy_arns)

#   role       = aws_iam_role.this[0].name
#   policy_arn = local.policy_arns[count.index]
# }

resource "aws_iam_role_policy_attachment" "this" {
  count = var.custom_policy_arns_count

  role       = aws_iam_role.this[0].name
  policy_arn = var.custom_policy_arns[count.index]
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = local.instance_profile_name
  role  = aws_iam_role.this[0].name
}
