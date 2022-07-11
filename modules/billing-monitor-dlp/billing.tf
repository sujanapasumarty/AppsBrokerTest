data "google_billing_account" "acct" {
  display_name = "My Billing Account"
  open         = true
} 
resource "google_project" "projects" {
  name       = var.project
  project_id = "samplesuji"
  org_id   = "396328517622"

  billing_account = data.google_billing_account.acct.id
} 
 
 resource "google_billing_budget" "budget" {
    project = var.project
  billing_account = "01B2F0-2A5E68-0523BA"
  display_name    = "Example Billing Budget"
  budget_filter {
    projects = ["projects/${data.google_project.projects.project}"]
    credit_types_treatment = "EXCLUDE_ALL_CREDITS"
  }


  amount {
    specified_amount {
      currency_code = "USD"
      units         = "100000"
    }
  }
  threshold_rules {
    threshold_percent = 0.5
  }
  all_updates_rule {
    monitoring_notification_channels = [
      google_monitoring_notification_channel.notification_channel.id,
    ]
    disable_default_iam_recipients = true
  }
} 