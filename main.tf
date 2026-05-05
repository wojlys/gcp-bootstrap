terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.8"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.7"
    }
  }
}

provider "google" {
  project = var.this_project
}

provider "tfe" {
  # we don't have to provide token = var.token as the token is configured HCP-side as an env variable TF_TOKEN
  # we don't have to proivde hostname = "app.terraform.io" as this is the default vaule
  organization = "wojlys-org"
}


