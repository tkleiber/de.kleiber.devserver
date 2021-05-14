# resource definitions

# OCI Provider
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}

# Compartment
resource "oci_identity_compartment" "tf_compartment" {
  # Required
  compartment_id   = var.root_compartment_id
  description      = var.compartment_desc
  name             = var.compartment_name
}

# Query Id from Availability Daomain
data "oci_identity_availability_domains" "ads" {
  compartment_id = oci_identity_compartment.tf_compartment.id
}

# Virtual Cloud Network
module "vcn"{
  source  = "oracle-terraform-modules/vcn/oci"
  version = "2.0.0"
  # insert the 4 required variables here

  # Required
  compartment_id = oci_identity_compartment.tf_compartment.id
  region = "eu-frankfurt-1"
  vcn_name = var.vcn_display_name
  vcn_dns_label = "adb"

  # Optional
  internet_gateway_enabled = true
  nat_gateway_enabled = false
  service_gateway_enabled = false
  vcn_cidr = var.vcn_cidr
}

# Sub Net
resource "oci_core_subnet" "tf_oci_core_subnet"{

  # Required
  compartment_id = oci_identity_compartment.tf_compartment.id
  vcn_id = module.vcn.vcn_id
  cidr_block = var.subnet_cidr_block

  # Optional
  route_table_id = module.vcn.nat_route_id
  display_name = var.subnet_display_name
}

# Compute Instance
resource "oci_core_instance" "tf_oci_core_instance" {
  # Required
  # Always Free exists only in the AD 3 of Regian Frankfurt, so the index is 2 instead of 0!
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
  compartment_id = oci_identity_compartment.tf_compartment.id
  shape = var.shape

  # Optional
  shape_config {
    baseline_ocpu_utilization = ""
    memory_in_gbs             = "1"
    ocpus                     = "1"
  }

  display_name = "DevelopmentServer"

  create_vnic_details {
    assign_public_ip = true
    subnet_id = oci_core_subnet.tf_oci_core_subnet.id
  }

  metadata = {
    ssh_authorized_keys = file(".oci/MyUbuntu.pub")
  }

  source_details {
    # image from https://docs.oracle.com/en-us/iaas/images/ubuntu-2004/
    source_id = var.source_id
    source_type = "image"
  }

  preserve_boot_volume = false
}