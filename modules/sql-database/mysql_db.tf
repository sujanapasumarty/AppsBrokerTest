resource "random_id" "db_name_suffix" {
  byte_length = 4
}


# create My SQL database instance
resource "google_sql_database_instance" "my_sql" {
  name                = "private-instance-${random_id.db_name_suffix.hex}"
  project             = var.project
  region              = "europe-west1"
  database_version    = var.db_version
  deletion_protection = false //if we dont keep this it will automatically take it as true

 /*  # Wait for the vpc connection to complete
  depends_on = [google_service_networking_connection.worker_pool_conn] */

  settings {
    tier              = var.db_tier
    activation_policy = var.db_activation_policy
    disk_autoresize   = var.db_disk_autoresize
    disk_size         = var.db_disk_size
    disk_type         = var.db_disk_type
    pricing_plan      = var.db_pricing_plan
    availability_type = "ZONAL"

    location_preference {
      zone = "europe-west1-b"
    }

    maintenance_window {
      day  = "7" # sunday
      hour = "3" # 3am  
    }

    backup_configuration {
      binary_log_enabled = true
      enabled            = true
      start_time         = "00:00"
    }

    ip_configuration {
      ipv4_enabled = false

      # Pass the private network link 
     private_network = var.network
     // private_network = cluster.google_compute_network.vpc_net_testproj.id  
     
  }

}
  depends_on = [
    google_service_networking_connection.vpc_peering
  ]
}

# create database
resource "google_sql_database" "my_sql_db" {
  name      = var.db_name
  project   = var.project
  instance  = google_sql_database_instance.my_sql.name
  charset   = var.db_charset
  collation = var.db_collation
}
//create a user in the instance
resource "google_sql_user" "admin_user" {
  project  = var.project
  name     = var.db_user
  instance = google_sql_database_instance.my_sql.name
  password = var.db_pass

}

resource "google_sql_user" "new_user" {
  project  = var.project
  name     = "new-user"
  instance = google_sql_database_instance.my_sql.name
  password = "password"
}