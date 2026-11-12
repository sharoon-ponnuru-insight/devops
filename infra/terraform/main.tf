resource "google_artifact_registry_repository" "this" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker artifact repository for application images"
  format        = upper(var.repository_format)

  labels = {
    environment = "sandbox"
    managed_by  = "terraform"
    owner       = "sada"
  }
}

output "repository_name" {
  description = "Artifact Registry repository name."
  value       = google_artifact_registry_repository.this.name
}

output "repository_url" {
  description = "Artifact Registry repository URL."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.this.repository_id}"
}
