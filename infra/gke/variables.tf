#################################
# Google Cloud Provider variables
#################################

variable "google_project" {
  description = "The ID of the project"
}

variable "google_region" {
  default     = "europe-west1"
  description = "The region to operate under"
}

#################################
# Kubernetes Provider variables
#################################

variable "gke_dashboard_disabled" {
  default = true
}

variable "gke_name" {
  default     = "cluster-1"
  description = "The name of GKE cluster"
}

variable "gke_node_count" {
  default     = 3
  description = "The number of nodes in GKE cluster"
}

variable "gke_version" {
  default = "1.8.4-gke.0"
}

variable "gke_zone" {
  default = "europe-west1-c"
}

variable "gke_node_size" {
  default     = 20
  description = "Size of the disk attached to each node"
}

variable "gke_node_machine_type" {
  default     = "n1-standard-1"
  description = "The name of a Google Compute Engine machine type"
}

variable "gke_node_image" {
  default     = "COS"
  description = "The image type to use for this node"
}
