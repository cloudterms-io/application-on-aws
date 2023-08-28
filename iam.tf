#######################################
# Attach custom policy
#######################################
data "aws_iam_policy_document" "policy_doc" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::application001/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::application001",
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "BucketAccessPolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.policy_doc.json
}

#######################################
# IAM Instance profile
#######################################
module "instance_profile" {

  source = "./modules/iam-instance-profile"

  create_instance_profile = true
  role_name               = "${var.project_name}-role"
  instance_profile_name   = "${var.project_name}-instance-profile"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy",
  ]
  custom_policy_arns = [
    aws_iam_policy.policy.arn
  ]
  role_path = "/"
}


