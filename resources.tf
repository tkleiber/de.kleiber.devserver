# resource definitions

# OCI Provider
provider oci {
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
}

# Compartment
resource oci_identity_compartment tf_compartment {
  # Required
  compartment_id   = var.root_compartment_id
  description      = var.compartment_desc
  name             = var.compartment_name
}

# Query Id from Availability Daomain
data oci_identity_availability_domains ads {
  #Required
  compartment_id = oci_identity_compartment.tf_compartment.id
}

# Virtual Cloud Network
resource oci_core_vcn tf_vcn {
  # Required
  compartment_id = oci_identity_compartment.tf_compartment.id
  # Optional
  # Use cidr_block instead of cidr_blocks prevents "Error Message: Count of CIDRs exceeds max limit: 0"
  cidr_block = var.vcn_cidr_block
  display_name  = var.vcn_display_name
}

# Route Table
resource oci_core_route_table tf_oci_core_route_table {
  #Required
  compartment_id = oci_identity_compartment.tf_compartment.id
  vcn_id = oci_core_vcn.tf_vcn.id
  #Optional
  display_name = "internet-route"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.tf_oci_core_internet_gateway.id
  }
}

# Security List
resource oci_core_security_list tf_oci_core_security_list {
  #Required
  compartment_id = oci_identity_compartment.tf_compartment.id
  vcn_id =  oci_core_vcn.tf_vcn.id
  display_name = "Security List for DevelopmentVcn"

  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol  = "all"
    stateless = "false"
  }

  ingress_security_rules {
    # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
    }
  }
  ingress_security_rules {
    # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
    icmp_options {
      code = "4"
      type = "3"
    }
    # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
  }

  ingress_security_rules {
    # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
    icmp_options {
      code = "-1"
      type = "3"
    }
    # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1
    protocol    = "1"
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }

  ingress_security_rules {
    description = "Allowing incoming requests from any IP address to port 8080 - this will be mapped to the Jenkins Docker Container"
    # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "8080"
      min = "8080"
    }
  }
}

# Sub Net
resource oci_core_subnet tf_oci_core_subnet {
  # Required
  cidr_block = var.subnet_cidr_block
  compartment_id = oci_identity_compartment.tf_compartment.id
  vcn_id = oci_core_vcn.tf_vcn.id
  # Optional
  dhcp_options_id = oci_core_vcn.tf_vcn.default_dhcp_options_id
  display_name = var.subnet_display_name
  route_table_id = oci_core_route_table.tf_oci_core_route_table.id
  security_list_ids = [
    oci_core_security_list.tf_oci_core_security_list.id,
  ]
}

# Internet Gateway
resource oci_core_internet_gateway tf_oci_core_internet_gateway {
  #Required
  compartment_id = oci_identity_compartment.tf_compartment.id
  vcn_id = oci_core_vcn.tf_vcn.id
  #Optional
  enabled = true
  display_name = var.ig_display_name
}

# Compute Instance
resource oci_core_instance tf_oci_core_instance {
  # Required
  # Always Free exists only in the AD 3 of Regian Frankfurt, so the index is 2 instead of 0!
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
  compartment_id = oci_identity_compartment.tf_compartment.id
  shape = var.shape
  # Optional
  create_vnic_details {
    assign_public_ip = true
    subnet_id = oci_core_subnet.tf_oci_core_subnet.id
  }
  display_name = "DevelopmentServer"
  fault_domain = "FAULT-DOMAIN-3"
  metadata = {
    ssh_authorized_keys = chomp(file(".oci/ubuntu.pub"))
    # YAML does only work embedded in data template_file like in
    # https://gist.github.com/scross01/5a66207fdc731dd99869a91461e9e2b8
    # so instead work with bash shell here
    user_data = base64encode(templatefile("bootstrap.sh", {
      jenkins_user = var.jenkins_user
      jenkins_password = var.jenkins_password
    }))
  }
  preserve_boot_volume = false
  shape_config {
    baseline_ocpu_utilization = ""
    memory_in_gbs             = "1"
    ocpus                     = "1"
  }
  source_details {
    # image from https://docs.oracle.com/en-us/iaas/images/ubuntu-2004/
    source_id = var.source_id
    source_type = "image"
  }
}
