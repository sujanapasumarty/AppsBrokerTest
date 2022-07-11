variable "bucket"{
  
}
/*  variable "api_key" {
  type        = string
  default = "credentials for accessing the iex api"
} */

variable "deployment_replica" {
  type        = number
  default = "3"
}

variable "container_image" {
  type        = string
  default = "europe-west2-docker.pkg.dev/samplesuji/my-repo/hello-second"
}

variable "roles" {
  type = list(string)
  default = ["roles/cloudsql.client"]
  description = "for authenticating the cloud sql proxy side car container"
}

variable "tls_crt" {
  type = string
  default = "tls certificate"
}

variable "tls_key" {
  type = string
  default = "tls key"
}

variable "cluster_zone" {
  default = "europe-west1"
}

variable "project" {

  default = "samplesuji"

}

variable "region" {
  default = "europe-west1"
}

variable "db_host" {
  type        = string
  default     = "127.0.0.1"
  description = "database host"
}
/* 
variable "name"{
  description = "namespace name"
} */


variable "namespace"{
 default = "dev"
} 