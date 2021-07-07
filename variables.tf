##############################################################################
# Variable block - See each variable description
##############################################################################

##############################################################################
# subnet_id - The ID of the subnet that the virtual server instance uses.
##############################################################################
//variable "subnet_id"{
//  default = ""
//  description = "The ID of the subnet within the VPC that the virtual server instance uses. Required for users to specify."
//}

##############################################################################
# ssh_key_name - The name of the public SSH key used to create the virtual server instance.
##############################################################################
variable "ssh_key_name" {
  default     = ""
  description = "The name of the public SSH key to use when creating the virtual server instance. Required for users to specify."
}

##############################################################################
# vsi_instance_name - The name of the virtual server instance.
##############################################################################
variable "vsi_instance_name" {
  default     = "plesk-centos-8"
  description = "The name of the virtual server instance. Required for users to specify."
}

##############################################################################
# vsi_profile - The profile of compute CPU and memory resources to use when creating the virtual server instance.
##############################################################################
variable "vsi_profile" {
  default     = "bx2-2x8"
  description = "The profile of compute CPU and memory resources to use when creating the virtual server instance. To list available profiles, run the `ibmcloud is instance-profiles` command."
}

variable "region" {
  default     = "us-south"
  description = "The region in which the VPC instance is located. Required for users to specify."
}

##############################################################################
# vsi_security_group - The security group to which the virtual server instance interface belongs to.
##############################################################################
variable "vsi_security_group" {
  default     = "plesk-security-group"
  description = "The name of the security group that is created. Required for users to specify."
}

variable "TF_VERSION" {
 default = "0.14"
 description = "The version of the Terraform engine that's used in the Schematics workspace."
}

variable "floating_ip" {
  default = "plesk-floating-ip"
  description = "Public floating IP needed for internet access"
}
