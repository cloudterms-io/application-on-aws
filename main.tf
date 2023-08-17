module "vpc" {

  source = "shamimice03/vpc/aws"

  vpc_name = "cloud-app-vpc"
  cidr     = "10.2.0.0/16"

  azs                 = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnet_cidr  = ["10.2.0.0/19", "10.2.32.0/19"]
  private_subnet_cidr = ["10.2.64.0/19", "10.2.96.0/19"]
  db_subnet_cidr      = ["10.2.128.0/19", "10.2.160.0/19"]


  enable_dns_hostnames      = true
  enable_dns_support        = true
  enable_single_nat_gateway = false

  tags = {
    "Team" = "devops"
    "Env"  = "dev"
  }
}

module "parameters" {

  source = "shamimice03/ssm-parameter/aws"

  parameters = [
    {
      name        = "/A4L/Wordpress/DBUser"
      type        = "String"
      description = "Parameter for webapp"
      value       = "a4lwordpressuser"
      tags = {
        "Name" = "webapp-params"
      }
    },
    {
      name        = "/A4L/Wordpress/DBName"
      type        = "String"
      description = "Parameter for webapp"
      value       = "a4lwordpressdb"
      tags = {
        "Name" = "webapp-params"
      }
    },
    {
      name        = "/A4L/Wordpress/DBEndpoint"
      type        = "String"
      description = "Parameter for webapp"
      value       = "localhost"
      tags = {
        "Name" = "webapp-params"
      }
    },
    {
      name        = "/A4L/Wordpress/DBPassword"
      type        = "SecureString"
      description = "Parameter for webapp"
      value       = "4n1m4l54L1f3"
      key_alias   = "alias/aws/ssm"
      tags = {
        "Name" = "webapp-params"
      }
    },
    {
      name        = "/A4L/Wordpress/DBRootPassword"
      type        = "SecureString"
      description = "Parameter for webapp"
      value       = "4n1m4l54L1f3"
      key_alias   = "alias/aws/ssm"
      tags = {
        "Name" = "webapp-params"
      }
    },
  ]
}
