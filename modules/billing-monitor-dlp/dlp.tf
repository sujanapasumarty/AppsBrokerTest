//Dlp Stored Info Type Dictionary

resource "google_data_loss_prevention_stored_info_type" "dict" {
  parent       = "projects/samplesuji"
  description  = "Description"
  display_name = "Displayname"

  dictionary {
    word_list {
      words = ["word", "word2"]
    }
  }
}

// Dlp Stored Info Type Large Custom dictionary
resource "google_data_loss_prevention_stored_info_type" "large" {
  parent       = "projects/samplesuji"
  description  = "Description"
  display_name = "Displayname"

  large_custom_dictionary {
    cloud_storage_file_set {
      url = "gs://${google_storage_bucket.gceme-artifacts.name}/${google_storage_bucket_object.object.name}"
    }
    output_path {
      path = "gs://${google_storage_bucket.gceme-artifacts.name}/touch.txt"
    }
  }
}


resource "fortimanager_object_dlp_sensor" "trname" {
  dlp_log            = "enable"
  extended_log       = "disable"
  feature_set        = "flow"
  full_archive_proto = ["ftp", "http-get", "http-post", "imap", "mapi", "nntp"]
  nac_quar_log       = "disable"
  name               = "terr-dlp-sensor"
  summary_proto      = ["ftp", "http-get", "http-post", "imap", "mapi", "nntp"]
}

 resource "google_data_loss_prevention_inspect_template" "custom" {
    parent = var.project
    description = "My description"
    display_name = "display_name"

    inspect_config {
        custom_info_types {
            info_type {
                name = "MY_CUSTOM_TYPE"
            }

            likelihood = "UNLIKELY"

            regex {
                pattern = "test*"
            }
        }

        info_types {
            name = "EMAIL_ADDRESS"
        }

        min_likelihood = "UNLIKELY"
        rule_set {
            info_types {
                name = "EMAIL_ADDRESS"
            }
            rules {
                exclusion_rule {
                    regex {
                        pattern = ".+@example.com"
                    }
                    matching_type = "MATCHING_TYPE_FULL_MATCH"
                }
            }
        }

        rule_set {
            info_types {
                name = "MY_CUSTOM_TYPE"
            }
            rules {
                hotword_rule {
                    hotword_regex {
                        pattern = "example*"
                    }
                    proximity {
                        window_before = 50
                    }
                    likelihood_adjustment {
                        fixed_likelihood = "VERY_LIKELY"
                    }
                }
            }
        }

        limits {
            max_findings_per_item    = 10
            max_findings_per_request = 50
        }
    }
} 