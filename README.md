# Plesk IBM Cloud Terraform Template
This repository containes the Terraform template used to deploly Plesk to IBM Cloud. This image used by this template contains CentOS 8 with Plesk pre-installed.

# Variables in variables.tf

subnet_id -- the ID of the subnet (not the name) it is required for the user to create before deploying.

ssh_key_name -- the user must add an SSH key before trying to deploy so they are able to login to the server.

vsi_instance_name -- This is the name of the Plesk VSI must be a name that is unique in the IBM cloud account

vis_profile -- The profile of compute CPU and memory resources to use when creating the virtual server instance. To list available profiles, run the `ibmcloud is instance-profiles` command.

region -- The region in which the VPC instance is located. Required for users to specify

vsi_security_group -- The name of the security group that is created. Required for users to specify

TF_VERSION -- The version of the Terraform engine that's used in the Schematics workspace. For this script to run properly it could be kept at 14 (most recent version supported by IBM cloud at time of writing)

floating_ip -- Public floating IP needed for internet access
