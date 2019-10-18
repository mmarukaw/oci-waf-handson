# Required variables
variable "compartment_id" {}
variable "zone_name" {}
variable "zone_zone_type" {}

# DNS Zone
resource "oci_dns_zone" "this" {
  #Required
  compartment_id = "${var.compartment_id}"
  name           = "${var.zone_name}"
  zone_type      = "${var.zone_zone_type}"

  /*
  #Optional
  defined_tags = "${var.zone_defined_tags}"
  external_masters {
    #Required
    address = "${var.zone_external_masters_address}"

    #Optional
    port = "${var.zone_external_masters_port}"
    tsig {
      #Required
      algorithm = "${var.zone_external_masters_tsig_algorithm}"
      name      = "${var.zone_external_masters_tsig_name}"
      secret    = "${var.zone_external_masters_tsig_secret}"
    }
  }
  freeform_tags = "${var.zone_freeform_tags}"
  */
}

output "id" {
  value = "${oci_dns_zone.this.id}"
}
