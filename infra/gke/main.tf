// Ensure GKE cluster is present and configured
resource "google_container_cluster" "cluster" {
  description        = "GKE Cluster for Reddit-app"
  enable_legacy_abac = false
  initial_node_count = "${var.gke_node_count}"
  min_master_version = "${var.gke_version}"
  name               = "${var.gke_name}"
  zone               = "${var.gke_zone}"

  addons_config {
    kubernetes_dashboard {
      disabled = "${var.gke_dashboard_disabled}"
    }
  }

  node_config {
    disk_size_gb = "${var.gke_node_size}"
    image_type   = "${var.gke_node_image}"
    machine_type = "${var.gke_node_machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  // configure kubectl
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.gke_name} --zone ${var.gke_zone} --project ${var.google_project}"
  }
}

// Ensure firewall rule for application access is present and configured
resource "google_compute_firewall" "firewall" {
  name        = "gke-reddit-app"
  description = "Allow access to reddit-app deployed in the Kubernetes"
  network     = "default"

  allow = {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
}
