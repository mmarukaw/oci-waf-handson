// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

variable "compartment_id" {
  default = "ocid1.compartment.oc1..aaaaaaaap7zxffy5cadhxdn363f6up4wnf5y2s7frdx5i7ecv6npdvsnrkra"
}

variable "lab_count" {
  default = 2
}

variable "domain" {
  default = "ocitutorials.tk"
}

variable "converted_domain" {
  default = "ocitutorials-tk"
}

variable "uri_prefix" {
  default = "web"
}

variable "precreated_waf_subdomain" {
  default = "block"
}
/*
# DNS Zone
resource "oci_dns_zone" "zone" {
  compartment_id = "${var.compartment_id}"
  name           = "${var.domain}"
  zone_type      = "PRIMARY"
}

# DNS A Records
resource "oci_dns_record" "a-records" {
  count = "${var.lab_count}"
  zone_name_or_id = "${var.domain}"
  domain          = "${var.uri_prefix}${count.index}.${var.domain}"
  rtype           = "A"
  compartment_id  = "${var.compartment_id}"
  rdata           = "1.2.3.4"
  ttl             = 30
}

# DNS CNAME Records
resource "oci_dns_record" "cname-records" {
  count = "${var.lab_count}"
  zone_name_or_id = "${var.domain}"
  domain          = "${var.uri_prefix}${count.index}.${var.precreated_waf_subdomain}.${var.domain}"
  rtype           = "CNAME"
  compartment_id = "${var.compartment_id}"
  rdata          = "${var.uri_prefix}${count.index}-${var.precreated_waf_subdomain}-${var.converted_domain}.b.waas.oci.oraclecloud.net."
  ttl            = 30
}
*/
data "oci_waas_waas_policy" "waas_policy" {
    #Required
    waas_policy_id = "ocid1.waaspolicy.oc1..aaaaaaaa2jo4a3big3r2vkxos5zqbghau3lcffmjb6y3wy4des2cfyblg2kq"
}
output "policy" {
    value = "${data.oci_waas_waas_policy.waas_policy}"
}

