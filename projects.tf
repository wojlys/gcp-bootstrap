/* Projects TF file */


######################
# Random suffixes for project names
######################

resource "random_string" "network_suffix" {
  length  = 4
  upper   = false
  numeric = true
  special = false
}

resource "random_string" "compute_suffix" {
  length  = 4
  upper   = false
  numeric = true
  special = false
}


######################
# Projects to be created under parent folder
# Notice!
# Default network creation is disabled via org policy
######################

resource "google_project" "network" {
  name            = format("rss-network-%s", random_string.network_suffix.result)
  project_id      = format("rss-network-%s", random_string.network_suffix.result)
  folder_id       = var.parent_folder_id
  billing_account = var.this_billing["network"]
  # allow terraform to delete project on destroy
  deletion_policy = "DELETE"

}


resource "google_project" "compute" {
  name            = format("rss-compute-%s", random_string.compute_suffix.result)
  project_id      = format("rss-compute-%s", random_string.compute_suffix.result)
  folder_id       = var.parent_folder_id
  billing_account = var.this_billing["compute"]
  # allow terraform to delete project on destroy
  deletion_policy = "DELETE"
}