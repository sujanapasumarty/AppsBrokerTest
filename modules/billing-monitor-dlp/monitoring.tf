
resource "google_monitoring_notification_channel" "notification_channel" {
  project      = var.project
  display_name = "Example Notification Channel"
  type         = "email"

  labels = {
    email_address = "sujana.toleti@gmail.com"
  }
}

resource "google_monitoring_alert_policy" "alert_policy" {
  project      = var.project
  display_name = "My Alert Policy"
  combiner     = "OR"
  conditions {
    display_name = "test condition"
    condition_threshold {
      filter     = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  user_labels = {
    foo = "bar"
  }
}


resource "google_monitoring_notification_channel" "default" {
  project      = var.project
  display_name = "Test Slack Channel"
  type         = "slack"
  labels = {
    "channel_name" = "#foobar"
  }
  sensitive_labels {
    auth_token = "one"
  }
}