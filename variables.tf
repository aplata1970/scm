#-----variables.tf-----
#=======================
#Each input variable accepted by a module must be declared using a variable block
variable "region" {
  type    = string
  default = "us-east-1"
}