resource "google_compute_shared_vpc_service_project" "svc_proj_attachment" {
  host_project    = var.host_project_ids[var.organization][var.environment]
  service_project = var.service_project_id
}

resource "google_project_service" "gke_svc" {
  project = var.service_project_id
  service = "container.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service_identity" "gke_hostagent_sa" {
  provider = google-beta
  project  = var.service_project_id
  service  = "container.googleapis.com"

  depends_on = [google_project_service.gke_svc]
}

resource "google_project_iam_member" "gke_hostagent_binding" {
  project = var.host_project_ids[var.organization][var.environment]
  role    = "roles/container.hostServiceAgentUser"
  member  = format("serviceAccount:%s", google_project_service_identity.gke_hostagent_sa.email)
}