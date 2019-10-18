# Required variables
variable "resource_count" {}
variable "zone_name" {}
variable "record_prefix" {}
variable "record_items_rtype" {}

# Optional variables
variable "compartment_id" { default = null }
variable "subdomain" { default = null }
variable "record_items_rdata" { default = null }
variable "record_items_ttl" { default = 30 }
variable "a_record_rdata" { default = null }
variable "cname_record_rdata" { default = null }
variable "waas_postfix" { default = ".b.waas.oci.oraclecloud.net."}


# DNS Record
resource "oci_dns_record" "this" {
  count = "${var.resource_count}"
  #Required
  zone_name_or_id = "${var.zone_name}"
  domain          = "${var.record_prefix}${count.index}${var.subdomain}.${var.zone_name}"
  rtype           = "${var.record_items_rtype}"

  #Optional
  compartment_id = "${var.compartment_id}"
#  rdata          = "${var.record_items_rdata}"
  rdata          = "${var.record_items_rtype == "A" ? var.a_record_rdata : "${var.record_prefix}${count.index}${var.subdomain}.${var.zone_name}${var.waas_postfix}"}"
  ttl            = "${var.record_items_ttl}"
}
