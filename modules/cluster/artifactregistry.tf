resource "google_artifact_registry_repository" "my-repo" {
  project       = var.project
  provider      = google-beta
  location      = "europe-west2"
  repository_id = var.repository_id
  description   = "example docker repository with cmek"
  format        = "DOCKER"
  // kms_key_name = "kms-key"
}

resource "google_artifact_registry_repository_iam_member" "test-iam" {
  project    = var.project
  provider   = google-beta
  location   = google_artifact_registry_repository.my-repo.location
  repository = google_artifact_registry_repository.my-repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.sp-name.email}"
}
