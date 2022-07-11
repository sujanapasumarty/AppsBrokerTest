// reserve internal static ip-range 
resource "google_compute_global_address" "peering_address" {
  project       = var.project
  name          = "vpc-sqldb"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  //network       = cluster.google_compute_network.vpc_net_testproj.id
  // network       = module.appsbroker-cluster.vpc_net_testproj.id
  network = var.network
  }

### setup private vpc connection between the default network and google cloud sql###
resource "google_service_networking_connection" "vpc_peering" {
  //  project_id = var.project
 // network                 = cluster.google_compute_network.vpc_net_testproj.id
  network       = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.peering_address.name]
 // depends_on              = [google_project_service.servicenetworking]
}
