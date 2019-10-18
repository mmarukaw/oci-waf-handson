// Common variables
variable "tenancy_ocid" {}
# variable "compartment_ocid" {}
variable "region" {}

// Configure the Oracle Cloud Infrastructure provider with an API Key
/*
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

provider "oci" {
  region           = "${var.region}"
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
}
*/

// Configure the Oracle Cloud Infrastructure provider to use Instance Principal based authentication
provider "oci" {
  auth   = "InstancePrincipal"
  region = "${var.region}"
}
