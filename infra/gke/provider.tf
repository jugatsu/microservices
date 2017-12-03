// Configure the Google Cloud provider
provider "google" {
  version = "~> 1.3.0"

  project = "${var.google_project}"
  region  = "${var.google_region}"
}

// Configure the Kubernetes provider
provider "kubernetes" {
  version = "~> 1.0.1"
}
