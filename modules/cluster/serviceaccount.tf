
resource "google_service_account" "sp-name" {
  project      = var.project
  account_id   = "sp-name"
  display_name = "SPasum"
  
}


resource "google_project_iam_member" "artifact_registry_admin" {
  project = var.project
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.sp-name.email}"
}

resource "google_project_iam_member" "default_sa_roles" {
  project = var.project
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.sp-name.email}"
}

/* resource "google_project_iam_member" "cloudbuild_sa_roles" {
  for_each = toset(var.iam_roles)
  project  = var.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.sp-name.email}"
}
 */
/*

resource "google_service_account_key" "mykey" {
  service_account_id = google_service_account.sp-name.name
  // public_key_type    = "TYPE_X509_PEM_FILE"
} 


resource "local_file" "myaccountjson" {
    content     = "${base64decode(google_service_account_key.mykey.private_key)}"
    filename = "${path.module}/sp-name.json"
}

 resource "google_service_account_iam_policy" "admin-account-iam" {
  service_account_id = google_service_account.sp-name.name
  policy_data        = data.google_iam_policy.admin.policy_data
} 

data "google_iam_policy" "admin" {
  binding {
   // role = "roles/iam.serviceAccountUser"
  role = "roles/artifactregistry.repoAdmin"
    members = [
      "serviceAccount:${google_service_account.sp-name.email}",
      ]
  }
  binding {
   
  role = "roles/artifactregistry.repoAdmin"
    members = [
      "serviceAccount:${google_service_account.sp-name.email}",
      ]
  }
 
  binding {
  role = "roles/iam.serviceAccountKeyAdmin"
    members = [
      "serviceAccount:${google_service_account.sp-name.email}",
      ]
  }
  
}

 */
