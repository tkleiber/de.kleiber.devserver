# output definitions
# Compartment
output "compartment_name" {
  value = oci_identity_compartment.tf_compartment.name
}
output "compartment_id" {
  value = oci_identity_compartment.tf_compartment.id
}

# Virtual Cloud Network
output "vcn_id" {
  value = module.vcn.vcn_id
}

# Virtual Cloud Network
output "private-subnet-name" {
  value = oci_core_subnet.tf_oci_core_subnet.display_name
}
output "private-subnet-OCID" {
  value = oci_core_subnet.tf_oci_core_subnet.id
}