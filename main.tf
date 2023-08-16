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
    enable_single_nat_gateway = true

    tags = {
      "Team" = "devops"
      "Env"  = "dev"
    }
}