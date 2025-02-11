#-----compute/main.tf-----
#==========================
provider "aws" {
  region = var.region
}

#Get Linux AMI ID using SSM Parameter endpoint
#===============================================
# A data source is accessed via a special kind of resource known as a data resource, declared using a data block:
data "aws_ssm_parameter" "webserver-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


# Template file
#==================
data "template_file" "user-init" {
  template = file("${path.module}/userdata.tpl")
}

#Create and bootstrap webserver
#===============================
#A resource block declares a resource of a given type ("aws_instance") with a given local name ("web"). 
resource "aws_instance" "webserver" {
 ami                         = data.aws_ssm_parameter.webserver-ami.value
 instance_type               = "t2.micro"
 associate_public_ip_address = true
 vpc_security_group_ids      = [var.security_group]
 subnet_id                   = var.subnets
 user_data                   = data.template_file.user-init.rendered
  tags = {
    Name = "webserver"
  }
}