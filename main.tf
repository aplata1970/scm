#-----main.tf-----
#===================
#The terraform block is used to configure settings related to terraform itself.
terraform {
  required_providers {
    aws = {
      version = "~> 3.44.0"
    }
  }
  required_version = ">= 0.15.5"
}
#The provider block is required for region
provider "aws" {
  region = var.region
}

#Deploy Networking Resources
/*A module is a container for multiple resources that are used together.
To call a module means to include the contents of that module into the configuration with specific values for its input variables. 
Modules are called from within other modules using module blocks*/
#============================
#This is the call for module vpc for deploying the AWS networking resources located under modules/vpc
module "vpc" {
  source = "./modules/vpc"
}

#Deploy Compute Resources
#============================
#o	This is the call for module compute for deploying AWS EC2 instances resources located under module/compute.
module "compute" {
  source         = "./modules/compute"
  subnets        = module.vpc.public_subnets
  security_group = module.vpc.public_sg
  subnet_ips     = module.vpc.subnet_ips
}