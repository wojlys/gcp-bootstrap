/* APIs */
resource "google_project_service" "network_project_apis" {
  for_each           = var.network_project_apis
  service            = each.value
  project            = google_project.network.project_id
  disable_on_destroy = false
}

resource "google_project_service" "compute_project_apis" {
  for_each           = var.compute_project_apis
  service            = each.value
  project            = google_project.compute.project_id
  disable_on_destroy = false
}