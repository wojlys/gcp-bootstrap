terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~>6.0"
    }
  }
}

provider "google" {
  project = "rss-bootstrap-nyww"
}

data "google_client_config" "current_config" {
  
}

// create nothing
output "project" {
  value = data.google_client_config.current_config.project
}