#creating vpc
//vpc_net_testproj vpc is for gke 
resource "google_compute_network" "vpc_net_testproj" {
  name                    = var.testprojvpc
  project                 = var.project
  auto_create_subnetworks = false
  // depends_on              = [google_project_service.servicenetworking]
}


#creating subnet
resource "google_compute_subnetwork" "vpc_subnet_test" {
  name          = var.subnettest
  project       = var.project
  region        = var.region
  ip_cidr_range = "10.244.252.0/22"                                 // "192.168.0.0/20"
  network       = google_compute_network.vpc_net_testproj.self_link #this is self linking and getting the name from 

  secondary_ip_range = [
    {
      range_name    = var.cluster_secondary_name # we are calling clusters secondary name
      ip_cidr_range = var.cluster_secondary_range_vpc
    },
    {
      range_name    = var.cluster_service_name
      ip_cidr_range = var.cluster_service_range
    }
  ]

}



resource "google_compute_firewall" "allowbasic" {
  name    = "allow-googleapis"
  project = var.project
  network = google_compute_network.vpc_net_testproj.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  target_tags = ["allow-google-apis"]

  direction = "EGRESS"

  priority = "1000"

  destination_ranges = ["199.36.153.8/30"] //,"82.38.176.208/28"]
}



###### External NAT IP (to be used by cloud-router for nodes-to-internet communication ###### 

//  linking with pool vpc
resource "google_compute_address" "nat2" {
  name    = format("%s-nat2-ip", var.newclustertest)
  project = var.project
  region  = var.region
  // address      = "192.168.0.0" //"10.0.0.0/16"   //
  // purpose       = "VPC_PEERING"
  // prefix_length = 20
  // network = google_compute_network.vpc_net_testproj.self_link
}

###### Create a cloud router (to be use by the Cloud NAT) ######
resource "google_compute_router" "router" {
  name    = format("%s-cloud-router", var.newclustertest)
  project = var.project
  region  = var.region
  network = google_compute_network.vpc_net_testproj.self_link
  // network = google_compute_network.vpc_net_petproj.self_link
}

###### Create a cloud NAT (Using cloud-router and NAT IP) ######
resource "google_compute_router_nat" "nat1" {
  name                               = format("%s-cloud-nat1", var.newclustertest)
  project                            = var.project
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat2.self_link]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"


  subnetwork {
    name = google_compute_subnetwork.vpc_subnet_test.self_link

    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]

    secondary_ip_range_names = [
      google_compute_subnetwork.vpc_subnet_test.secondary_ip_range.0.range_name,
      google_compute_subnetwork.vpc_subnet_test.secondary_ip_range.1.range_name
    ]

  }

}



/*  ###### Create a cloud NAT (Using cloud-router and NAT IP) ######
resource "google_compute_router_nat" "nat2" {
    name    = format("%s-cloud-nat2", var.newclustertest)
    project = var.project
    router  = google_compute_router.router.name
    region  = var.region
    nat_ip_allocate_option = "MANUAL_ONLY"
    nat_ips = [google_compute_address.nat2.self_link]
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"


    subnetwork{
        name = google_compute_subnetwork.vpc_subnet_test.self_link

        source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]

        secondary_ip_range_names=[
            google_compute_subnetwork.vpc_subnet_test.secondary_ip_range.0.range_name,
            google_compute_subnetwork.vpc_subnet_test.secondary_ip_range.1.range_name
        ]

    }

}  */

