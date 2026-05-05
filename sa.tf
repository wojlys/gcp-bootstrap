/* Infra projects service accounts */
resource "google_service_account" "sa_network" {
  account_id   = "network-sa"
  project      = google_project.network.project_id
  display_name = "RSS Network Service Account"
  depends_on   = [google_project_service.network_project_apis]
}

resource "google_service_account" "sa_compute" {
  account_id   = "compute-sa"
  project      = google_project.compute.project_id
  display_name = "RSS Compute Service Account"
  depends_on   = [google_project_service.compute_project_apis]
}