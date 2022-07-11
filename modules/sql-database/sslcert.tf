resource "google_sql_ssl_cert" "mysql_client_cert" {
  common_name = "mysql_common_name"
  instance    = google_sql_database_instance.my_sql.name
}