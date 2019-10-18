// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

variable "compartment_id" {}
variable "lab_count" {}
variable "domain" {}
variable "uri_prefix" {}
variable "precreated_waf_subdomain" {}
variable "lab_waf_subdomain" {}

locals {
  converted_domain = replace(var.domain, ".", "-")
}

# DNS Zone
resource "oci_dns_zone" "zone" {
  compartment_id = "${var.compartment_id}"
  name           = "${var.domain}"
  zone_type      = "PRIMARY"
}

# DNS A Records
resource "oci_dns_record" "a_records" {
  count = "${var.lab_count}"
  zone_name_or_id = "${var.domain}"
  domain          = "${var.uri_prefix}${count.index}.${var.domain}"
  rtype           = "A"
  compartment_id  = "${var.compartment_id}"
  rdata           = "140.238.60.141"
  ttl             = 30
}

# DNS CNAME Records for precreated WAF policies
resource "oci_dns_record" "cname_records" {
  count = "${var.lab_count}"
  zone_name_or_id = "${var.domain}"
  domain          = "${var.uri_prefix}${count.index}.${var.precreated_waf_subdomain}.${var.domain}"
  rtype           = "CNAME"
  compartment_id = "${var.compartment_id}"
  rdata          = "${var.uri_prefix}${count.index}-${var.precreated_waf_subdomain}-${local.converted_domain}.b.waas.oci.oraclecloud.net."
  ttl            = 30
}

# DNS CNAME Records for lab WAF policies
resource "oci_dns_record" "lab_cname_records" {
  count = "${var.lab_count}"
  zone_name_or_id = "${var.domain}"
  domain          = "${var.uri_prefix}${count.index}.${var.lab_waf_subdomain}.${var.domain}"
  rtype           = "CNAME"
  compartment_id = "${var.compartment_id}"
  rdata          = "${var.uri_prefix}${count.index}-${var.lab_waf_subdomain}-${local.converted_domain}.b.waas.oci.oraclecloud.net."
  ttl            = 30
}

# WAAS Policies
resource "oci_waas_waas_policy" "waas_policies" {
  count          = "${var.lab_count}"
  compartment_id = "${var.compartment_id}"
  domain         = "${var.uri_prefix}${count.index}.${var.precreated_waf_subdomain}.${var.domain}"
  display_name   = "${var.uri_prefix}${count.index}.${var.precreated_waf_subdomain}.${var.domain}"
  origin_groups {
    label = "originGroups1"
    origin_group {
      origin = "${var.uri_prefix}${count.index}.${var.precreated_waf_subdomain}.${var.domain}"
      weight = "1"
    }
  }
  origins {
    label = "${var.uri_prefix}${count.index}.${var.precreated_waf_subdomain}.${var.domain}"
    uri   = "${var.uri_prefix}${count.index}.${var.domain}"
    custom_headers {
      name  = "undefined"
      value = "undefined"
    }
    http_port  = 80
    https_port = 443
  }

  policy_config {
    certificate_id                = ""
    cipher_group                  = ""
    client_address_header         = ""
    is_behind_cdn                 = false
    is_cache_control_respected    = false
    is_https_enabled              = false
    is_https_forced               = false
    is_origin_compression_enabled = false
    is_response_buffering_enabled = false
    tls_protocols                 = []
  }

  waf_config {
    origin = "${var.uri_prefix}${count.index}.${var.precreated_waf_subdomain}.${var.domain}"
    origin_groups = ["originGroups1"]
    /*
    protection_settings {
      #Optional
      allowed_http_methods = "${var.waas_policy_waf_config_protection_settings_allowed_http_methods}"
      block_action = "${var.waas_policy_waf_config_protection_settings_block_action}"
      block_error_page_code = "${var.waas_policy_waf_config_protection_settings_block_error_page_code}"
      block_error_page_description = "${var.waas_policy_waf_config_protection_settings_block_error_page_description}"
      block_error_page_message = "${var.waas_policy_waf_config_protection_settings_block_error_page_message}"
      block_response_code = "${var.waas_policy_waf_config_protection_settings_block_response_code}"
      is_response_inspected = "${var.waas_policy_waf_config_protection_settings_is_response_inspected}"
      max_argument_count = "${var.waas_policy_waf_config_protection_settings_max_argument_count}"
      max_name_length_per_argument = "${var.waas_policy_waf_config_protection_settings_max_name_length_per_argument}"
      max_response_size_in_ki_b = "${var.waas_policy_waf_config_protection_settings_max_response_size_in_ki_b}"
      max_total_name_length_of_arguments = "${var.waas_policy_waf_config_protection_settings_max_total_name_length_of_arguments}"
      media_types = "${var.waas_policy_waf_config_protection_settings_media_types}"
      recommendations_period_in_days = "${var.waas_policy_waf_config_protection_settings_recommendations_period_in_days}"
    }
    access_rules {
      #Required
      action = "${var.waas_policy_waf_config_access_rules_action}"
      criteria {
        #Required
        condition = "${var.waas_policy_waf_config_access_rules_criteria_condition}"
        value = "${var.waas_policy_waf_config_access_rules_criteria_value}"
      }
      name = "${var.waas_policy_waf_config_access_rules_name}"
      #Optional
      block_action = "${var.waas_policy_waf_config_access_rules_block_action}"
      block_error_page_code = "${var.waas_policy_waf_config_access_rules_block_error_page_code}"
      block_error_page_description = "${var.waas_policy_waf_config_access_rules_block_error_page_description}"
      block_error_page_message = "${var.waas_policy_waf_config_access_rules_block_error_page_message}"
      block_response_code = "${var.waas_policy_waf_config_access_rules_block_response_code}"
      bypass_challenges = "${var.waas_policy_waf_config_access_rules_bypass_challenges}"
      redirect_response_code = "${var.waas_policy_waf_config_access_rules_redirect_response_code}"
      redirect_url = "${var.waas_policy_waf_config_access_rules_redirect_url}"
    }
    */
    address_rate_limiting {
      #Required
      is_enabled = false
      #Optional
      #allowed_rate_per_address = "${var.waas_policy_waf_config_address_rate_limiting_allowed_rate_per_address}"
      #block_response_code = "${var.waas_policy_waf_config_address_rate_limiting_block_response_code}"
      #max_delayed_count_per_address = "${var.waas_policy_waf_config_address_rate_limiting_max_delayed_count_per_address}"
    }
    /*
    caching_rules {
      #Required
      action = "${var.waas_policy_waf_config_caching_rules_action}"
      criteria {
        #Required
        condition = "${var.waas_policy_waf_config_caching_rules_criteria_condition}"
        value = "${var.waas_policy_waf_config_caching_rules_criteria_value}"
      }
      name = "${var.waas_policy_waf_config_caching_rules_name}"
      #Optional
      caching_duration = "${var.waas_policy_waf_config_caching_rules_caching_duration}"
      client_caching_duration = "${var.waas_policy_waf_config_caching_rules_client_caching_duration}"
      is_client_caching_enabled = "${var.waas_policy_waf_config_caching_rules_is_client_caching_enabled}"
      key = "${var.waas_policy_waf_config_caching_rules_key}"
    }
    */
    captchas {
      #Required
      failure_message = "CAPTCHAが正しくありませんでした。再試行してください。"
      session_expiration_in_seconds = 300
      submit_label = "はい、私は人間です。"
      title = "あなたは人間ですか。"
      url = "/captcha"
      #Optional
      footer_text = "上のイメージに表示されている文字と数字を入力してください。"
      header_text = "このWebサイトへのアクセスの試行回数が増加していることが検出されました。このサイトの安全を維持できるように、次のイメージのテキストを入力して、あなたがロボットではないことを示してください。"
    }
    /*
    custom_protection_rules {
      #Optional
      action = "${var.waas_policy_waf_config_custom_protection_rules_action}"
      id = "${var.waas_policy_waf_config_custom_protection_rules_id}"
    }
    */
    device_fingerprint_challenge {
      #Required
      is_enabled = false
      #Optional
      #action = "${var.waas_policy_waf_config_device_fingerprint_challenge_action}"
      #action_expiration_in_seconds = "${var.waas_policy_waf_config_device_fingerprint_challenge_action_expiration_in_seconds}"
      #challenge_settings {
      #Optional
      #block_action = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_block_action}"
      #block_error_page_code = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_block_error_page_code}"
      #block_error_page_description = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_block_error_page_description}"
      #block_error_page_message = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_block_error_page_message}"
      #block_response_code = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_block_response_code}"
      #captcha_footer = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_captcha_footer}"
      #captcha_header = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_captcha_header}"
      #captcha_submit_label = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_captcha_submit_label}"
      #captcha_title = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_captcha_title}"
      #}
      #failure_threshold = "${var.waas_policy_waf_config_device_fingerprint_challenge_failure_threshold}"
      #failure_threshold_expiration_in_seconds = "${var.waas_policy_waf_config_device_fingerprint_challenge_failure_threshold_expiration_in_seconds}"
      #max_address_count = "${var.waas_policy_waf_config_device_fingerprint_challenge_max_address_count}"
      #max_address_count_expiration_in_seconds = "${var.waas_policy_waf_config_device_fingerprint_challenge_max_address_count_expiration_in_seconds}"
    }
    human_interaction_challenge {
      #Required
      is_enabled = true
      #Optional
      action = "BLOCK"
      action_expiration_in_seconds = 60
      failure_threshold = 10
      failure_threshold_expiration_in_seconds = 60
      interaction_threshold = 3
      recording_period_in_seconds = 15
      /*
      challenge_settings {
        #Optional
        block_action = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_block_action}"
        block_error_page_code = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_block_error_page_code}"
        block_error_page_description = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_block_error_page_description}"
        block_error_page_message = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_block_error_page_message}"
        block_response_code = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_block_response_code}"
        captcha_footer = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_captcha_footer}"
        captcha_header = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_captcha_header}"
        captcha_submit_label = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_captcha_submit_label}"
        captcha_title = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_captcha_title}"
      }
      set_http_header {
        Required
        name = "${var.waas_policy_waf_config_human_interaction_challenge_set_http_header_name}"
        value = "${var.waas_policy_waf_config_human_interaction_challenge_set_http_header_value}"
      }
      */
    }
    js_challenge {
      #Required
      is_enabled = true
      #Optional
      action = "BLOCK"
      action_expiration_in_seconds = 60
      failure_threshold = 10
      /*
      challenge_settings {
        Optional
        block_action = "${var.waas_policy_waf_config_js_challenge_challenge_settings_block_action}"
        block_error_page_code = "${var.waas_policy_waf_config_js_challenge_challenge_settings_block_error_page_code}"
        block_error_page_description = "${var.waas_policy_waf_config_js_challenge_challenge_settings_block_error_page_description}"
        block_error_page_message = "${var.waas_policy_waf_config_js_challenge_challenge_settings_block_error_page_message}"
        block_response_code = "${var.waas_policy_waf_config_js_challenge_challenge_settings_block_response_code}"
        captcha_footer = "${var.waas_policy_waf_config_js_challenge_challenge_settings_captcha_footer}"
        captcha_header = "${var.waas_policy_waf_config_js_challenge_challenge_settings_captcha_header}"
        captcha_submit_label = "${var.waas_policy_waf_config_js_challenge_challenge_settings_captcha_submit_label}"
        captcha_title = "${var.waas_policy_waf_config_js_challenge_challenge_settings_captcha_title}"
      }
      set_http_header {
        Required
        name = "x-jsc-alerts"
        value = "{failed_amount}"
      }
      */
    }
    /*
    whitelists {
      #Required
      addresses = "${var.waas_policy_waf_config_whitelists_addresses}"
      name = "${var.waas_policy_waf_config_whitelists_name}"
    }
    */
  }
}
