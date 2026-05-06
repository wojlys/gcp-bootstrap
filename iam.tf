/* IAM Role Bindings file */

######################
# Allow Bootstrap SA to manage infra projects SA
# Required role: roles/iam.workloadIdentityPoolAdmin
# Targets: Network and Compute projects
######################

# -
# By default, the principal that created a project gets a roles/owner role
# This role is too broad for bootstrap-sa so in the next step we will
# add only the roles required by SA bootstrap to finish the seed configuration
# and then we will remove roles/owner from both infra projects 
# -


locals {
  minimal_roles_required = ["roles/serviceusage.serviceUsageAdmin", "roles/iam.serviceAccountAdmin", "roles/iam.workloadIdentityPoolAdmin", "roles/resourcemanager.projectIamAdmin"]
  bootstrap_sa           = "rss-bootstrap-nyww-sa@rss-bootstrap-nyww.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "network" {
  for_each = toset(local.minimal_roles_required)
  project  = google_project.network.project_id
  role     = each.value
  member   = "serviceAccount:${local.bootstrap_sa}"
}

resource "google_project_iam_member_remove" "network" {
  role       = "roles/owner"
  project    = google_project.network.project_id
  member     = "serviceAccount:${local.bootstrap_sa}"
  depends_on = [google_project_iam_member.network]
}

resource "google_project_iam_member" "compute" {
  for_each = toset(local.minimal_roles_required)
  project  = google_project.compute.project_id
  role     = each.value
  member   = "serviceAccount:${local.bootstrap_sa}"
}

resource "google_project_iam_member_remove" "compute" {
  role       = "roles/owner"
  project    = google_project.compute.project_id
  member     = "serviceAccount:${local.bootstrap_sa}"
  depends_on = [google_project_iam_member.compute]
}


# -
# WIF binding
# Here, we have to add 'roles/workloadIdentityUser' on each project's SA for 
# where a member is specific principalSet 
# this allows HCP to impersonate SA in each project BUT DO NOT GIVE RIGHTS TO DO ANYTHING YET 
# -
# Warning! service_account_id has to be a reference to <sa>.name ! 
resource "google_service_account_iam_member" "sa_network" {
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.sa_network.name
  member             = "principalSet://iam.googleapis.com/projects/${google_project.network.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.network_wif_pool.workload_identity_pool_id}/attribute.terraform_workspace_name/gcp-network"
  depends_on         = [google_iam_workload_identity_pool_provider.network_wif_provider]
}

resource "google_service_account_iam_member" "sa_compute" {
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.sa_compute.name
  member             = "principalSet://iam.googleapis.com/projects/${google_project.compute.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.compute_wif_pool.workload_identity_pool_id}/attribute.terraform_workspace_name/gcp-compute"
  depends_on         = [google_iam_workload_identity_pool_provider.compute_wif_provider]
}


# -
# Now, we need to add  roles required by project's SA to manage project's resources
# -
resource "google_project_iam_member" "sa_network" {
  for_each = var.network_sa_roles
  project  = google_project.network.project_id
  member   = "serviceAccount:${google_service_account.sa_network.email}"
  role     = each.value
}


resource "google_project_iam_member" "sa_compute" {
  for_each = var.compute_sa_roles
  project  = google_project.compute.project_id
  member   = "serviceAccount:${google_service_account.sa_compute.email}"
  role     = each.value
}