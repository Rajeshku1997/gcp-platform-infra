resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  network    = var.network_id
  subnetwork = var.subnet_id

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false
}


resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-nodes"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  project    = var.project_id

  node_count = 2

  node_config {
    machine_type = "e2-standard-2"

    service_account = var.node_service_account

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      environment = "dev"
      managed_by  = "terraform"
    }

    tags = [
      "gke-node"
    ]

    disk_type    = "pd-balanced"
    disk_size_gb = 50
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
