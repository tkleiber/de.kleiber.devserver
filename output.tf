# output definitions
output "public-ip" {
  value = oci_core_instance.tf_oci_core_instance.public_ip
}