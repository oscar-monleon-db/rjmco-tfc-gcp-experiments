resource "google_project_service" "gke_svc" {
  project = var.project_id
  service = "container.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service_identity" "gke_hostagent_sa" {
  provider = google-beta
  project  = var.project_id
  service  = "container.googleapis.com"

  depends_on = [google_project_service.gke_svc]
}

resource "google_project_iam_member" "gke_hostagent_binding" {
  project = var.project_id
  role    = "roles/container.hostServiceAgentUser"
  member  = format("serviceAccount:%s", google_project_service_identity.gke_hostagent_sa.email)
}