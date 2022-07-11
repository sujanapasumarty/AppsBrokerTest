variable "cluster_zone" {
  default = "europe-west1"
}

variable "project" {

  default = "samplesuji"

}

variable "cluster_secondary_name" {
  default = "subnettestpod"
}

variable "cluster_service_name" {
  default = "public-services-testproject"
}

variable "master_cidr" {
  // default = "199.36.153.8/30"
  default = "172.16.0.32/28"
}

variable "node_count" {
  default = 2
}

variable "autoscaling_min_node_count" {
  default = 1
}

variable "autoscaling_max_node_count" {
  default = 3
}

variable "disk_size_gb" {
  default = 50
}

variable "disk_type" {
  default = "pd-standard"
}

variable "machine_type" {
  default = "n1-standard-2"
}

variable "region" {
  default = "europe-west1"
}

variable "cluster_secondary_range_vpc" {
  default = "10.4.0.0/14"
}


variable "cluster_service_range" {
  default = "10.0.32.0/20"
}


variable "testprojvpc" {
  default = "vpc-net-testproj"
}

/* variable "privatepoolvpc" {
    default = "private-pool-vpc"
}
 */
variable "subnettest" {
  default = "vpc-subnet-test"
}

/* variable "subnettest2" {
    default = "sub-test-vpc2"
}
variable "pvtpoolvpcsubnet1" {
    default = "pvt-pool-vpcsubnet1"
}
variable "pvtpoolvpcsubnet2" {
    default = "pvt-pool-vpcsubnet2"
} */

variable "newclustertest" {
  default = "clustertestproj-artifact"
}

variable "service_account_email" {
  default = ""
}

variable "master_global_access_config" {
  type        = list(object({ enabled = bool }))
  description = "enabled - Enable the cluster master globally or not."

  default = [{
    "enabled" = true
  }]
}



/* 
variable "source_repo_name" {} */

variable "trigger_name" {
  default = "cicd-sample-main"
}

variable "repository_id" {
  default = "my-repo"

}

variable "iam_roles" {
  description = "Roles that will be added to service account"
  type        = list(string)
  default = ["roles/iam.serviceAccountUser",
    "roles/clouddeploy.operator",
    "roles/container.admin",
    "roles/dlp.admin",
    "roles/cloudkms.admin",
    "roles/storage.objectViewer",
    "roles/servicemanagement.serviceController",
    "roles/logging.logWriter",
    "roles/monitoring.admin",
    "roles/cloudtrace.agent",
    "roles/artifactregistry.reader"
    /* "roles/serviceusage.serviceUsageViewer",
    "roles/serviceusage.serviceUsageConsumer",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/serviceusage.services.use" */

  ]
  // "roles/billing.creator", "roles/billing.admin" , "roles/billing.costsManager", "roles/billing.viewer", "roles/billing.projectManager"]
}


// --------------------------------------------//
// db instance variables //

variable "db_version" {
  description = "The version of of the database. For example, MYSQL_5_6 or MYSQL_5_7"
  default     = "MYSQL_5_7"
}

variable "db_tier" {
  description = "The machine tier (First Generation) or type (Second Generation). Reference: https://cloud.google.com/sql/pricing"
  default     = "db-f1-micro"
}

variable "db_activation_policy" {
  description = "Specifies when the instance should be active. Options are ALWAYS, NEVER or ON_DEMAND"
  default     = "Always"
}

variable "db_disk_autoresize" {
  description = "Second Generation only. Configuration to increase storage size automatically."
  default     = true
}

variable "db_disk_size" {
  description = "Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  default     = 10
}

variable "db_disk_type" {
  description = "Second generation only. The type of data disk: PD_SSD or PD_HDD"
  default     = "PD_SSD"
}

variable "db_pricing_plan" {
  description = "First generation only. Pricing plan for this instance, can be one of PER_USE or PACKAGE"
  default     = "PER_USE"
}

variable "db_name" {
  description = "Name of the default database to create"
  default     = "tfdb"
}

variable "db_charset" {
  description = "The charset for the default database"
  default     = ""
}

variable "db_collation" {
  description = "The collation for the default database. Example for MySQL databases: 'utf8_general_ci'"
  default     = ""
}

variable "db_instance_access_cidr" {
  description = "The IPv4 CIDR to provide access the database instance"
  default     = "0.0.0.0/0"
}



variable "apis_to_activate" {
  description = "apis that will be enabled"
  type        = list(string)
  default = ["iam.googleapis.com",
    "servicenetworking.googleapis.com",
    "artifactregistry.googleapis.com",
    "container.googleapis.com",
    "clouddeploy.googleapis.com",
    "cloudbuild.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "dlp.googleapis.com",
    "billingbudgets.googleapis.com",
    "cloudbilling.googleapis.com"
  ]
}


variable "db_user" {
  description = "username for sql instance"
  default     = "sujana"
}

variable "db_pass" {
  description = "password for sql instance"
  default     = "Password"
}

variable "roles" {
  type        = list(string)
  default     = ["roles/cloudsql.client"]
  description = "for authenticating the cloud sql proxy side car container"
}

//-----------------------------------------------------------------------------------------------------

/* variable "member" {
  description = "service account"
  default     = "serviceAccount:${google_service_account.sp-name.email}"
} */
/* 
variable "network"{
  description ="vpc for testvpc"
  //default = google_compute_network.
}
 */

/* variable "namespace"{
  
}
 */