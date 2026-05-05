data "tfe_project" "remote_state_test" {
  name = "remote-state-test"
}

locals {
  hcp_wif_vars = {
    compute = {
      TFC_GCP_PROVIDER_AUTH             = true
      TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL = google_service_account.sa_compute.email
      TFC_GCP_PROJECT_NUMBER            = google_project.compute.number
      TFC_GCP_WORKLOAD_POOL_ID          = google_iam_workload_identity_pool.compute_wif_pool.workload_identity_pool_id
      TFC_GCP_WORKLOAD_PROVIDER_ID      = google_iam_workload_identity_pool_provider.compute_wif_provider.workload_identity_pool_provider_id
    },
    network = {
      TFC_GCP_PROVIDER_AUTH             = true
      TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL = google_service_account.sa_network.email
      TFC_GCP_PROJECT_NUMBER            = google_project.network.number
      TFC_GCP_WORKLOAD_POOL_ID          = google_iam_workload_identity_pool.network_wif_pool.workload_identity_pool_id
      TFC_GCP_WORKLOAD_PROVIDER_ID      = google_iam_workload_identity_pool_provider.network_wif_provider.workload_identity_pool_provider_id
    }
  }
}


// Let's create two workspaces
resource "tfe_workspace" "gcp_network" {
  name       = "gcp-network"
  project_id = data.tfe_project.remote_state_test.id
}

resource "tfe_workspace" "gcp_compute" {
  name       = "gcp-compute"
  project_id = data.tfe_project.remote_state_test.id
}

// Let's add WIF-required env variable to each workspace with values used for gcp
resource "tfe_variable" "gcp_network_wif_vars" {
  for_each     = tomap(local.hcp_wif_vars["network"])
  key          = each.key
  value        = tostring(each.value)
  category     = "env"
  workspace_id = tfe_workspace.gcp_network.id
  depends_on   = [tfe_workspace.gcp_network, google_iam_workload_identity_pool_provider.network_wif_provider, google_project.network, google_service_account.sa_network, google_service_account_iam_member.sa_network]
}

resource "tfe_variable" "gcp_compute_wif_vars" {
  for_each     = tomap(local.hcp_wif_vars["compute"])
  key          = each.key
  value        = tostring(each.value)
  category     = "env"
  workspace_id = tfe_workspace.gcp_compute.id
  depends_on   = [tfe_workspace.gcp_compute, google_iam_workload_identity_pool_provider.compute_wif_provider, google_project.compute, google_service_account.sa_compute, google_service_account_iam_member.sa_compute]
}

// finally, we configure remote state/output sharing from workspace gcp-network to gcp-compute
resource "tfe_workspace_settings" "network_workspace_settings" {
  workspace_id              = tfe_workspace.gcp_network.id
  execution_mode            = "remote"
  global_remote_state       = false
  remote_state_consumer_ids = [tfe_workspace.gcp_compute.id]
}

resource "tfe_workspace_settings" "compute_network_settings" {
  workspace_id        = tfe_workspace.gcp_compute.id
  execution_mode      = "remote"
  global_remote_state = false
}