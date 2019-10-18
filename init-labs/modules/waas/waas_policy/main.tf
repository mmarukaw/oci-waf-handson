# Required variables
variable "resource_count" {}
variable "compartment_id" {}
variable "waas_policy_domain" {}
variable "waas_policy_subdomain" {}
variable "waas_policy_uri_prefix" {}
#variable "" {}

# Optional variables
#variable "" {}

# WAAS Policy
resource "oci_waas_waas_policy" "test_waas_policy" {
  count          = "${var.resource_count}"
  #Required
  compartment_id = "${var.compartment_id}"
  domain         = "${var.waas_policy_uri_prefix}${count.index}.${var.waas_policy_subdomain}.${var.waas_policy_domain}"

  #Optional
  /*
  additional_domains = "${var.waas_policy_additional_domains}"
  defined_tags       = { "Operations.CostCenter" = "42" }
  display_name       = "${var.waas_policy_display_name}"
  freeform_tags      = { "Department" = "Finance" }
  origin_groups {

    #Optional
    origins = "${var.waas_policy_origin_groups_origins}"
  }
  */
  origins {
    #Required
    label = "${var.waas_policy_uri_prefix}${count.index}.${var.waas_policy_subdomain}.${var.waas_policy_domain}"
    uri = "${var.waas_policy_uri_prefix}${count.index}.${var.waas_policy_domain}"

    /*
    #Optional
    custom_headers {
      #Required
      name  = "${var.waas_policy_origins_custom_headers_name}"
      value = "${var.waas_policy_origins_custom_headers_value}"
    }
    http_port  = "${var.waas_policy_origins_http_port}"
    https_port = "${var.waas_policy_origins_https_port}"
    */
  }
  /*
  policy_config {
    #Optional
    certificate_id                = "${oci_waas_certificate.test_certificate.id}"
    cipher_group                  = "${var.waas_policy_policy_config_cipher_group}"
    client_address_header         = "${var.waas_policy_policy_config_client_address_header}"
    is_behind_cdn                 = "${var.waas_policy_policy_config_is_behind_cdn}"
    is_cache_control_respected    = "${var.waas_policy_policy_config_is_cache_control_respected}"
    is_https_enabled              = "${var.waas_policy_policy_config_is_https_enabled}"
    is_https_forced               = "${var.waas_policy_policy_config_is_https_forced}"
    is_origin_compression_enabled = "${var.waas_policy_policy_config_is_origin_compression_enabled}"
    is_response_buffering_enabled = "${var.waas_policy_policy_config_is_response_buffering_enabled}"
    tls_protocols                 = "${var.waas_policy_policy_config_tls_protocols}"
  }
  waf_config {
    #Optional
    access_rules {
      #Required
      action = "${var.waas_policy_waf_config_access_rules_action}"
      criteria {
        #Required
        condition = "${var.waas_policy_waf_config_access_rules_criteria_condition}"
        value     = "${var.waas_policy_waf_config_access_rules_criteria_value}"
      }
      name = "${var.waas_policy_waf_config_access_rules_name}"

      #Optional
      block_action                 = "${var.waas_policy_waf_config_access_rules_block_action}"
      block_error_page_code        = "${var.waas_policy_waf_config_access_rules_block_error_page_code}"
      block_error_page_description = "${var.waas_policy_waf_config_access_rules_block_error_page_description}"
      block_error_page_message     = "${var.waas_policy_waf_config_access_rules_block_error_page_message}"
      block_response_code          = "${var.waas_policy_waf_config_access_rules_block_response_code}"
      bypass_challenges            = "${var.waas_policy_waf_config_access_rules_bypass_challenges}"
      redirect_response_code       = "${var.waas_policy_waf_config_access_rules_redirect_response_code}"
      redirect_url                 = "${var.waas_policy_waf_config_access_rules_redirect_url}"
    }
    address_rate_limiting {
      #Required
      is_enabled = "${var.waas_policy_waf_config_address_rate_limiting_is_enabled}"

      #Optional
      allowed_rate_per_address      = "${var.waas_policy_waf_config_address_rate_limiting_allowed_rate_per_address}"
      block_response_code           = "${var.waas_policy_waf_config_address_rate_limiting_block_response_code}"
      max_delayed_count_per_address = "${var.waas_policy_waf_config_address_rate_limiting_max_delayed_count_per_address}"
    }
    caching_rules {
      #Required
      action = "${var.waas_policy_waf_config_caching_rules_action}"
      criteria {
        #Required
        condition = "${var.waas_policy_waf_config_caching_rules_criteria_condition}"
        value     = "${var.waas_policy_waf_config_caching_rules_criteria_value}"
      }
      name = "${var.waas_policy_waf_config_caching_rules_name}"

      #Optional
      caching_duration          = "${var.waas_policy_waf_config_caching_rules_caching_duration}"
      client_caching_duration   = "${var.waas_policy_waf_config_caching_rules_client_caching_duration}"
      is_client_caching_enabled = "${var.waas_policy_waf_config_caching_rules_is_client_caching_enabled}"
      key                       = "${var.waas_policy_waf_config_caching_rules_key}"
    }
    captchas {
      #Required
      failure_message               = "${var.waas_policy_waf_config_captchas_failure_message}"
      session_expiration_in_seconds = "${var.waas_policy_waf_config_captchas_session_expiration_in_seconds}"
      submit_label                  = "${var.waas_policy_waf_config_captchas_submit_label}"
      title                         = "${var.waas_policy_waf_config_captchas_title}"
      url                           = "${var.waas_policy_waf_config_captchas_url}"

      #Optional
      footer_text = "${var.waas_policy_waf_config_captchas_footer_text}"
      header_text = "${var.waas_policy_waf_config_captchas_header_text}"
    }
    custom_protection_rules {

      #Optional
      action = "${var.waas_policy_waf_config_custom_protection_rules_action}"
      id     = "${var.waas_policy_waf_config_custom_protection_rules_id}"
    }
    device_fingerprint_challenge {
      #Required
      is_enabled = "${var.waas_policy_waf_config_device_fingerprint_challenge_is_enabled}"

      #Optional
      action                       = "${var.waas_policy_waf_config_device_fingerprint_challenge_action}"
      action_expiration_in_seconds = "${var.waas_policy_waf_config_device_fingerprint_challenge_action_expiration_in_seconds}"
      challenge_settings {

        #Optional
        block_action                 = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_block_action}"
        block_error_page_code        = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_block_error_page_code}"
        block_error_page_description = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_block_error_page_description}"
        block_error_page_message     = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_block_error_page_message}"
        block_response_code          = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_block_response_code}"
        captcha_footer               = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_captcha_footer}"
        captcha_header               = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_captcha_header}"
        captcha_submit_label         = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_captcha_submit_label}"
        captcha_title                = "${var.waas_policy_waf_config_device_fingerprint_challenge_challenge_settings_captcha_title}"
      }
      failure_threshold                       = "${var.waas_policy_waf_config_device_fingerprint_challenge_failure_threshold}"
      failure_threshold_expiration_in_seconds = "${var.waas_policy_waf_config_device_fingerprint_challenge_failure_threshold_expiration_in_seconds}"
      max_address_count                       = "${var.waas_policy_waf_config_device_fingerprint_challenge_max_address_count}"
      max_address_count_expiration_in_seconds = "${var.waas_policy_waf_config_device_fingerprint_challenge_max_address_count_expiration_in_seconds}"
    }
    human_interaction_challenge {
      #Required
      is_enabled = "${var.waas_policy_waf_config_human_interaction_challenge_is_enabled}"

      #Optional
      action                       = "${var.waas_policy_waf_config_human_interaction_challenge_action}"
      action_expiration_in_seconds = "${var.waas_policy_waf_config_human_interaction_challenge_action_expiration_in_seconds}"
      challenge_settings {

        #Optional
        block_action                 = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_block_action}"
        block_error_page_code        = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_block_error_page_code}"
        block_error_page_description = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_block_error_page_description}"
        block_error_page_message     = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_block_error_page_message}"
        block_response_code          = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_block_response_code}"
        captcha_footer               = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_captcha_footer}"
        captcha_header               = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_captcha_header}"
        captcha_submit_label         = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_captcha_submit_label}"
        captcha_title                = "${var.waas_policy_waf_config_human_interaction_challenge_challenge_settings_captcha_title}"
      }
      failure_threshold                       = "${var.waas_policy_waf_config_human_interaction_challenge_failure_threshold}"
      failure_threshold_expiration_in_seconds = "${var.waas_policy_waf_config_human_interaction_challenge_failure_threshold_expiration_in_seconds}"
      interaction_threshold                   = "${var.waas_policy_waf_config_human_interaction_challenge_interaction_threshold}"
      recording_period_in_seconds             = "${var.waas_policy_waf_config_human_interaction_challenge_recording_period_in_seconds}"
      set_http_header {
        #Required
        name  = "${var.waas_policy_waf_config_human_interaction_challenge_set_http_header_name}"
        value = "${var.waas_policy_waf_config_human_interaction_challenge_set_http_header_value}"
      }
    }
    js_challenge {
      #Required
      is_enabled = "${var.waas_policy_waf_config_js_challenge_is_enabled}"

      #Optional
      action                       = "${var.waas_policy_waf_config_js_challenge_action}"
      action_expiration_in_seconds = "${var.waas_policy_waf_config_js_challenge_action_expiration_in_seconds}"
      challenge_settings {

        #Optional
        block_action                 = "${var.waas_policy_waf_config_js_challenge_challenge_settings_block_action}"
        block_error_page_code        = "${var.waas_policy_waf_config_js_challenge_challenge_settings_block_error_page_code}"
        block_error_page_description = "${var.waas_policy_waf_config_js_challenge_challenge_settings_block_error_page_description}"
        block_error_page_message     = "${var.waas_policy_waf_config_js_challenge_challenge_settings_block_error_page_message}"
        block_response_code          = "${var.waas_policy_waf_config_js_challenge_challenge_settings_block_response_code}"
        captcha_footer               = "${var.waas_policy_waf_config_js_challenge_challenge_settings_captcha_footer}"
        captcha_header               = "${var.waas_policy_waf_config_js_challenge_challenge_settings_captcha_header}"
        captcha_submit_label         = "${var.waas_policy_waf_config_js_challenge_challenge_settings_captcha_submit_label}"
        captcha_title                = "${var.waas_policy_waf_config_js_challenge_challenge_settings_captcha_title}"
      }
      failure_threshold = "${var.waas_policy_waf_config_js_challenge_failure_threshold}"
      set_http_header {
        #Required
        name  = "${var.waas_policy_waf_config_js_challenge_set_http_header_name}"
        value = "${var.waas_policy_waf_config_js_challenge_set_http_header_value}"
      }
    }
    origin        = "${var.waas_policy_waf_config_origin}"
    origin_groups = "${var.waas_policy_waf_config_origin_groups}"
    protection_settings {

      #Optional
      allowed_http_methods               = "${var.waas_policy_waf_config_protection_settings_allowed_http_methods}"
      block_action                       = "${var.waas_policy_waf_config_protection_settings_block_action}"
      block_error_page_code              = "${var.waas_policy_waf_config_protection_settings_block_error_page_code}"
      block_error_page_description       = "${var.waas_policy_waf_config_protection_settings_block_error_page_description}"
      block_error_page_message           = "${var.waas_policy_waf_config_protection_settings_block_error_page_message}"
      block_response_code                = "${var.waas_policy_waf_config_protection_settings_block_response_code}"
      is_response_inspected              = "${var.waas_policy_waf_config_protection_settings_is_response_inspected}"
      max_argument_count                 = "${var.waas_policy_waf_config_protection_settings_max_argument_count}"
      max_name_length_per_argument       = "${var.waas_policy_waf_config_protection_settings_max_name_length_per_argument}"
      max_response_size_in_ki_b          = "${var.waas_policy_waf_config_protection_settings_max_response_size_in_ki_b}"
      max_total_name_length_of_arguments = "${var.waas_policy_waf_config_protection_settings_max_total_name_length_of_arguments}"
      media_types                        = "${var.waas_policy_waf_config_protection_settings_media_types}"
      recommendations_period_in_days     = "${var.waas_policy_waf_config_protection_settings_recommendations_period_in_days}"
    }
    whitelists {
      #Required
      addresses = "${var.waas_policy_waf_config_whitelists_addresses}"
      name      = "${var.waas_policy_waf_config_whitelists_name}"
    }
  }
  */
}

