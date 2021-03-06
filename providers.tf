terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.11.0"
    }
  }
}

provider "google-beta" {
  project = var.project
  region  = var.region
}

/* // configure the terraform backend to use a workspace in terraform cloud
terraform {
  backend "remote" {
    organization = "SujanaSPlanet"

    workspaces {
      name = "simplesujana"
    }
  }
} */
