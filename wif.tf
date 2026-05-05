/* WIF Pool and WIF provider */

resource "google_iam_workload_identity_pool" "network_wif_pool" {
  workload_identity_pool_id = "network-wif-pool"
  description               = "Workload Identity Federation Pool for Network Project"
  project                   = google_project.network.project_id
  display_name              = "RSS Network WIF Pool"
  depends_on                = [google_project_service.network_project_apis]
}


resource "google_iam_workload_identity_pool_provider" "network_wif_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.network_wif_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "network-wif-provider"
  project                            = google_project.network.project_id
  disabled                           = false
  description                        = "HCP OIDC provider for Network project"
  attribute_mapping = {
    "google.subject"                        = "assertion.sub"
    "attribute.terraform_organization_name" = "assertion.terraform_organization_name"
    "attribute.terraform_project_name"      = "assertion.terraform_project_name"
    "attribute.terraform_workspace_name"    = "assertion.terraform_workspace_name"
    "attribute.terraform_run_phase"         = "assertion.terraform_run_phase"
  }
  attribute_condition = <<EOT
  assertion.terraform_organization_name == 'wojlys-org' && 
  assertion.terraform_project_name == 'remote-state-test' && 
  assertion.terraform_workspace_name == 'gcp-network' && 
  ( 
    assertion.terraform_run_phase == 'plan' ||  
    assertion.terraform_run_phase == 'apply' 
  )
EOT
  oidc {
    issuer_uri = "https://app.terraform.io"
  }
}


resource "google_iam_workload_identity_pool" "compute_wif_pool" {
  workload_identity_pool_id = "compute-wif-pool"
  description               = "Workload Identity Federation Pool for Compute Project"
  project                   = google_project.compute.project_id
  display_name              = "RSS Compute WIF Pool"
  depends_on                = [google_project_service.compute_project_apis]
}



resource "google_iam_workload_identity_pool_provider" "compute_wif_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.compute_wif_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "compute-wif-provider"
  project                            = google_project.compute.project_id
  disabled                           = false
  description                        = "HCP OIDC provider for compute project"
  attribute_mapping = {
    "google.subject"                        = "assertion.sub"
    "attribute.terraform_organization_name" = "assertion.terraform_organization_name"
    "attribute.terraform_project_name"      = "assertion.terraform_project_name"
    "attribute.terraform_workspace_name"    = "assertion.terraform_workspace_name"
    "attribute.terraform_run_phase"         = "assertion.terraform_run_phase"
  }
  attribute_condition = <<EOT
  assertion.terraform_organization_name == 'wojlys-org' && 
  assertion.terraform_project_name == 'remote-state-test' && 
  assertion.terraform_workspace_name == 'gcp-compute' && 
  ( 
    assertion.terraform_run_phase == 'plan' ||  
    assertion.terraform_run_phase == 'apply' 
  )
EOT
  oidc {
    issuer_uri = "https://app.terraform.io"
  }
}
