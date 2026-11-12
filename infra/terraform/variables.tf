variable "project_id" {
  description = "The Google Cloud project where the Artifact Registry repository will be created."
  type        = string
  default     = "sada-seed-2025-sandbox"
}

variable "region" {
  description = "The Google Cloud region for the Artifact Registry repository."
  type        = string
  default     = "us-central1"
}

variable "repository_id" {
  description = "The Artifact Registry repository ID."
  type        = string
  default     = "sada-docker"
}

variable "repository_format" {
  description = "Repository format to create in Artifact Registry."
  type        = string
  default     = "DOCKER"

  validation {
    condition = contains([
      "DOCKER",
      "MAVEN",
      "NPM",
      "PYTHON",
      "APT",
      "YUM"
    ], upper(var.repository_format))
    error_message = "The repository format must be one of: DOCKER, MAVEN, NPM, PYTHON, APT, YUM."
  }
}
