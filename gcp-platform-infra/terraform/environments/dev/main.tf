module "network" {
  source = "../../modules/network"

  network_name = var.network_name
  subnet_name  = var.subnet_name

  region = var.region

  subnet_cidr   = "10.10.0.0/20"
  pods_cidr     = "10.20.0.0/16"
  services_cidr = "10.30.0.0/20"
}

module "iam" {
  source = "../../modules/iam"

  project_id  = var.project_id
  environment = var.environment
}

module "gke" {
  source = "../../modules/gke"

  project_id   = var.project_id
  region       = var.region
  cluster_name = var.cluster_name

  network_id = module.network.network_id
  subnet_id  = module.network.subnet_id

  node_service_account = module.iam.gke_node_service_account_email
}

module "project_services" {
  source = "../../modules/project-services"

  project_id = var.project_id
}
