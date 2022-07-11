output "vpc-net-testproj" {
  value = google_compute_network.vpc_net_testproj
}

output "vpc-subnet-test" {
  value = google_compute_subnetwork.vpc_subnet_test
}

output "my-repo" {
  value = google_artifact_registry_repository.my-repo
}

output "sp-name" {
  value = google_service_account.sp-name
}

/* output "cluster_set" {
  value = google_container_cluster.cluster_set
} */

output "dummynode1" {
  value = google_container_node_pool.dummynode1
}

/* output "storage-cluster-endpoint"{
  value = google_storage_bucket_object.cluster_endpoint
}

output "storage-cluster-cert"{
  value = google_storage_bucket_object.cluster_cert
} */