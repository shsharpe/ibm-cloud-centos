##############################################################################
# This is default entrypoint.
#  - Ensure user provided region is valid
#  - Ensure user provided resource_group is valid
#################################################################################
provider "ibm" {
  generation            = 2 
  region                = var.region
  ibmcloud_timeout      = 300
}

##############################################################################
# Read/validate Region
##############################################################################
data "ibm_is_region" "region" {
  name = var.region
}

##############################################################################
# This file creates the compute instances for the solution.
# - Virtual Server using custom image id
##############################################################################

##############################################################################
# Read/validate sshkey
##############################################################################
data "ibm_is_ssh_key" "vsi_ssh_pub_key" {
  name = var.ssh_key_name
}

##############################################################################
# Read/validate vsi profile
##############################################################################
data "ibm_is_instance_profile" "vsi_profile" {
  name = var.vsi_profile
}

##############################################################################
#  - Create VPC
##############################################################################

resource "ibm_is_vpc" "vsi_vpc" {
  name = "plesk-vpc"
  default_security_group_name = var.vsi_security_group
}

##############################################################################
#  - Create subnet
##############################################################################
resource "ibm_is_subnet" "vsi_subnet"{
   name = "plesk-subnet"
   zone = format("%s-%s", var.region, "1")
   vpc =  ibm_is_vpc.vsi_vpc.id
   total_ipv4_address_count = "256"
}

##############################################################################
# Create Plesk CentOS 8 Server
##############################################################################

//security group
//resource "ibm_is_security_group" "vsi_security_group" {
 // name           = var.vsi_security_group
 // vpc            = ibm_is_subnet.vsi_subnet.vpc
 // resource_group = ibm_is_subnet.vsi_subnet.resource_group
//}

//security group rule SSH
resource "ibm_is_security_group_rule" "vsi_sg_allow_ssh" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

//Security Group Rule Plesk Admin HTTPS
resource "ibm_is_security_group_rule" "vsi_sg_allow_plesk_admin_https" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 8443
    port_max = 8443
  }
}

//Security Group Rule Plesk Admin HTTP
resource "ibm_is_security_group_rule" "vsi_sg_allow_plesk_admin_http" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 8880
    port_max = 8880
  }
}

//Security Group Rule Web Server HTTP
resource "ibm_is_security_group_rule" "vsi_sg_allow_web_server_http" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 80
    port_max = 80
  }
}

//Security Group Rule Web Server HTTPS
resource "ibm_is_security_group_rule" "vsi_sg_allow_web_server_https" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}

//Security Group Rule FTP
resource "ibm_is_security_group_rule" "vsi_sg_allow_ftp" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 21
    port_max = 21
  }
}

//Security Group Rule SMTP
resource "ibm_is_security_group_rule" "vsi_sg_allow_smtp" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 25
    port_max = 25
  }
}

resource "ibm_is_security_group_rule" "vsi_sg_allow_smtp_secure" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 465
    port_max = 465
  }
}

//security group rule pop3

resource "ibm_is_security_group_rule" "vsi_sg_allow_pop" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 110
    port_max = 110
  }
}

resource "ibm_is_security_group_rule" "vsi_sg_allow_pop_secure" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 995
    port_max = 995
  }
}

//Security group rule IMAP

resource "ibm_is_security_group_rule" "vsi_sg_allow_imap" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 143
    port_max = 143
  }
}

resource "ibm_is_security_group_rule" "vsi_sg_allow_imap_secure" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 993
    port_max = 993
  }
}

resource "ibm_is_security_group_rule" "vsi_sg_allow_mysql" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 3306
    port_max = 3306
  }
}

//Security group rule Postgres

resource "ibm_is_security_group_rule" "vsi_sg_allow_postgres" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 5432
    port_max = 5432
  }
}

//security group Domain Name Server TCP

resource "ibm_is_security_group_rule" "vsi_sg_allow_dns" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 53
    port_max = 53
  }
}

resource "ibm_is_security_group_rule" "vsi_sg_allow_dns_udp" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  udp {
    port_min = 53
    port_max = 53
  }
}

//security group rule plesk installer and plesk updates

resource "ibm_is_security_group_rule" "vsi_sg_allow_plesk_installer" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  udp {
    port_min = 8447
    port_max = 8447
  }
}

//security group rule to allow all for outbound
resource "ibm_is_security_group_rule" "vsi_sg_rule_out_all" {
  depends_on = [ibm_is_vpc.vsi_vpc.security_group]
  group     = ibm_is_vpc.vsi_vpc.security_group.group_id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}
 
//vsi instance 
resource "ibm_is_instance" "plesk_vsi" {
  depends_on = [ibm_is_security_group_rule.vsi_sg_rule_out_all]
  name           = var.vsi_instance_name
  image          = local.image_map[var.region]
  profile        = data.ibm_is_instance_profile.vsi_profile.name
  resource_group = ibm_is_subnet.vsi_subnet.resource_group

  primary_network_interface {
    name = "eth0"
    subnet = ibm_is_subnet.vsi_subnet.id
    security_groups = [ibm_is_vpc.vsi_vpc.security_group.group_id]
  }
  
  vpc  = ibm_is_subnet.vsi_subnet.vpc
  zone = ibm_is_subnet.vsi_subnet.zone
  keys = [data.ibm_is_ssh_key.vsi_ssh_pub_key.id]
}

resource "ibm_is_floating_ip" "plesk_floatingip" {
  name = var.floating_ip
  target = ibm_is_instance.plesk_vsi.primary_network_interface[0].id
}

