/* output "storage-cluster-endpoint"{
  // value = google_storage_bucket_object.cluster_endpoint
  value = "${data.google_storage_bucket_object.cluster_endpoint.content}"
}

output "storage-cluster-cert"{
  value = "${data.google_storage_bucket_object.cluster_cert.content}"
} */
/* 
output "k8snamespace"{
    value = kubernetes_namespace.dev
} */

output "name" {
  value       = kubernetes_namespace.dev.metadata[0].name
  description = "Namespace name"
}

