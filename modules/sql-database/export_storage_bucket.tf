resource "google_storage_bucket" "gceme-artifacts" {
  name     = var.sqldbname
  project  = var.project
  location = var.region
  
}

// export the cloud sql instance connection name to a cloud storage bucket
resource "google_storage_bucket_object" "db_connection" {
  name   = "connection-name"
  content = "${google_sql_database_instance.my_sql.connection_name}"
  bucket = google_storage_bucket.gceme-artifacts.name
}

// export the database user name to a cloud storage bucket
resource "google_storage_bucket_object" "db_user" {
  name    = "db_user"
  content = google_sql_user.admin_user.name
  bucket  = google_storage_bucket.gceme-artifacts.name
}


// export the database user password to a cloud storage bucket
resource "google_storage_bucket_object" "db_pass" {
  name    = "db_pass"
  content = google_sql_user.admin_user.password
  bucket  = google_storage_bucket.gceme-artifacts.name
}


// export the database name to a cloud storage bucket
resource "google_storage_bucket_object" "db" {
  name    = "db"
  content = google_sql_database.my_sql_db.name
  bucket  = google_storage_bucket.gceme-artifacts.name
}


