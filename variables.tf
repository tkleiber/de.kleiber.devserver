# variable definitions

# OCI Provider
variable "tenancy_ocid" { type = string }
variable "user_ocid" { type = string }
variable "private_key_path" { type = string }
variable "fingerprint" { type = string }
variable "region" { type = string }
variable "root_compartment_id" { type = string }

# Compartment
variable "compartment_name" { type = string }
variable "compartment_desc" { type = string }

# Virtual Cloud Network
variable "vcn_display_name" { type = string }
variable "vcn_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

# Sub Net
variable "subnet_display_name" { type = string }
variable "subnet_cidr_block" {
  type    = string
  default = "10.0.0.0/24"
}

# Internet Gateway
variable "ig_display_name" { type = string }

# Compute Instance
variable "shape" { type = string }
variable "source_id" { type = string }

