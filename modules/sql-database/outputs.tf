

output "peering_address"{
    value = google_compute_global_address.peering_address
}

output "vpc_peering"{
    value = google_service_networking_connection.vpc_peering
}

output "samplesuji-gceme-artifacts"{
    value = google_storage_bucket.gceme-artifacts
}

output "my_sql"{
    value = google_sql_database_instance.my_sql
}

output "my_sql_db"{
    value = google_sql_database.my_sql_db
}

output "admin_user"{
    value = google_sql_user.admin_user
}

output "new_user"{
    value = google_sql_user.new_user
}
